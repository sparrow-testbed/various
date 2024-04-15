//
//  JRPhotoPreviewController.m
//  JRPodPrivate_Example
//
//  Created by 金煜祥 on 2020/9/22.
//  Copyright © 2020 wni. All rights reserved.
//

#import "JRPhotoPreviewController.h"
#import "JRUIKit.h"

@interface JRPhotoPreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView * thumbCollectionView;
@property (nonatomic,assign)BOOL bottomEnable;
@end

@implementation JRPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(64, 59);
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.thumbCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BottomHeight-52-69, SCREEN_WIDTH, 69) collectionViewLayout:layout];
    [self.thumbCollectionView collectionViewLayoutAlignmentLeft];
    [self.view addSubview:self.thumbCollectionView];
    self.thumbCollectionView.delegate = self;
    self.thumbCollectionView.dataSource = self;
    self.thumbCollectionView.showsHorizontalScrollIndicator = NO;
    self.thumbCollectionView.backgroundColor = [UIColor whiteColor];
    [self.thumbCollectionView registerClass:[JRThumbImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    TZImagePickerController * pickerController = (TZImagePickerController *)self.navigationController;
    if(pickerController.selectedModels.count > 0){
        self.thumbCollectionView.hidden = NO;
    }else{
        self.thumbCollectionView.hidden = YES;
    }
    UICollectionView * collectionView = [self valueForKey:@"collectionView"];
    [collectionView registerClass:[JRVideoPreviewCell class] forCellWithReuseIdentifier:@"JRVideoPreviewCell"];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"预览";
    UIView * _naviBar = [self valueForKey:@"_naviBar"];
    titleLabel.frame = CGRectMake(self.view.width/2 - 30, StateHeight + 8, 60, 32);
    
    titleLabel.textColor = [UIColor whiteColor];

    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_naviBar addSubview:titleLabel];
    
    titleLabel.hidden = !self.onlyShowSelectModel;
   
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}



- (void)refreshSelectButtonImageViewContentMode {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIButton * _selectButton = [self valueForKey:@"_selectButton"];
        if (_selectButton.imageView.image.size.width <= 27) {
            _selectButton.imageView.contentMode = UIViewContentModeCenter;
        } else {
            _selectButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        [self.thumbCollectionView reloadData];
        
        [self hideThumbCollectionView];
        [self resetBottomEnable];
    });
    
}



- (void)showPhotoBytes {
    TZImagePickerController * pickerController = (TZImagePickerController *)self.navigationController;
    [[TZImageManager manager] getPhotosBytesWithArray:pickerController.selectedModels completion:^(NSString *totalBytes) {
        UILabel * orPhotoLabel = [self valueForKey:@"_originalPhotoLabel"];
        if (![totalBytes isEqualToString:@"0B"]) {
            orPhotoLabel.text =[NSString stringWithFormat:@"(共%@)",totalBytes];
        }else{
            orPhotoLabel.text = @"";
        }
        
        
    }];
}
#pragma mark -UICollectionViewDataSource,UICollectionViewDelegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.thumbCollectionView]) {
        TZImagePickerController * pickerController = (TZImagePickerController *)self.navigationController;
        return self.onlyShowSelectModel ? self.models.count : pickerController.selectedModels.count;
        
    }
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.thumbCollectionView]) {
        
        JRThumbImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        TZImagePickerController * pickerController = (TZImagePickerController *)self.navigationController;
        NSArray * dataArray = self.onlyShowSelectModel ? self.models : pickerController.selectedModels;
        
        TZAssetModel * model = [dataArray objectAtIndex:indexPath.row];
        
        TZAssetModel * currectModel = [self.models objectAtIndex:self.currentIndex];
        if ([currectModel.asset isEqual:model.asset]) {
            cell.jrIsSelected = YES;
        }else{
            cell.jrIsSelected = NO;
        }
        if (model.thumbImage) {
            cell.thumbImageView.image = model.thumbImage;
        }
        if (model.type == TZAssetModelMediaTypeVideo) {
            cell.videoFlagImageView.hidden = NO;
        }else{
            cell.videoFlagImageView.hidden = YES;
        }
        
       
        if (self.onlyShowSelectModel) {
            BOOL contain = NO;
            for (TZAssetModel * tmpModel in pickerController.selectedModels) {
                if ([model.asset.localIdentifier isEqualToString:tmpModel.asset.localIdentifier]) {
                    contain = YES;
                    break;
                }
            }
            if (!contain) {
                cell.maskView.hidden = NO;
             
            }else{
                cell.maskView.hidden = YES;
            }
        }
        
        if (!model.thumbImage) {
            [[TZImageManager manager] getPhotoWithAsset:model.asset photoWidth:120 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                if (!isDegraded && photo ) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.thumbImageView.image = photo;
                        model.thumbImage = photo;
                    });
                    
                }
            }];
        }
        return cell;
    }
    JRImagePickerController *_tzImagePickerVc = (JRImagePickerController *)self.navigationController;
    TZAssetModel *model = self.models[indexPath.item];
    
    TZAssetPreviewCell *cell;
    __weak typeof(self) weakSelf = self;
    if (_tzImagePickerVc.allowPickingMultipleVideo && model.type == TZAssetModelMediaTypeVideo) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JRVideoPreviewCell" forIndexPath:indexPath];
        JRVideoPreviewCell *currentCell = (JRVideoPreviewCell *)cell;
        currentCell.iCloudSyncFailedHandle = ^(id asset, BOOL isSyncFailed) {
            model.iCloudFailed = isSyncFailed;
            [weakSelf performSelector:@selector(didICloudSyncStatusChanged:) withObject:model];
            [weakSelf.models replaceObjectAtIndex:indexPath.item withObject:model];
            
        };
        
        if(!currentCell.warningView){
            currentCell.warningView = [[UIView alloc]init];
            [currentCell addSubview:currentCell.warningView];
            [currentCell.warningView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(currentCell);
                make.top.equalTo(currentCell).offset(NaviHeight);
                make.height.equalTo(@36);
            }];
            currentCell.warningView.backgroundColor =  [UIColor jk_colorWithHexString:@"#3A3A3A"];
            currentCell.warningView.alpha = 0.9;
            UIImageView * warningImageView = [[UIImageView alloc]initWithImage:[JRUIHelper imageNamed:@"warning-circle"]];
            //        _warningView.tag = TipViewTag;
            [currentCell.warningView addSubview:warningImageView];
            [warningImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(currentCell.warningView).offset(26);
                make.centerY.equalTo(currentCell.warningView.mas_centerY);
                make.width.height.equalTo(@20);
            }];
            
            UILabel * warningLabel = [[UILabel alloc]init];
            warningLabel.font = [UIFont systemFontOfSize:14];
            warningLabel.textColor = [UIColor jk_colorWithHexString:@"#FFFFFF"];
            warningLabel.tag = 1001;
            [currentCell.warningView addSubview:warningLabel];
            [warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(warningImageView.mas_right).offset(7);
                make.right.equalTo(currentCell.warningView.mas_right).offset(30);
                make.centerY.equalTo(currentCell.warningView.mas_centerY);
            }];
        }
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.networkAccessAllowed = YES;
        currentCell.warningView.hidden = YES;
        
        UILabel * warningLabel = (UILabel *)[currentCell.warningView viewWithTag:1001];
        
        warningLabel.text = [NSString stringWithFormat:@"视频时长超过%ld分钟,无法分享",(long)_tzImagePickerVc.videoLimitMaxDuration];
        BOOL  flag = model.asset.duration > _tzImagePickerVc.videoLimitMaxDuration * 60 && _tzImagePickerVc.videoLimitMaxDuration > 0;
        currentCell.warningView.hidden =!flag;
        currentCell.jrIsShowWarning = flag;
        
    } else if (_tzImagePickerVc.allowPickingMultipleVideo && model.type == TZAssetModelMediaTypePhotoGif && _tzImagePickerVc.allowPickingGif) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZGifPreviewCell" forIndexPath:indexPath];
        TZGifPreviewCell *currentCell = (TZGifPreviewCell *)cell;
        currentCell.previewView.iCloudSyncFailedHandle = ^(id asset, BOOL isSyncFailed) {
            model.iCloudFailed = isSyncFailed;
            [weakSelf performSelector:@selector(didICloudSyncStatusChanged:) withObject:model];
            [weakSelf.models replaceObjectAtIndex:indexPath.item withObject:model];
        };
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZPhotoPreviewCell" forIndexPath:indexPath];
        TZPhotoPreviewCell *photoPreviewCell = (TZPhotoPreviewCell *)cell;
        photoPreviewCell.cropRect = _tzImagePickerVc.cropRect;
        photoPreviewCell.allowCrop = _tzImagePickerVc.allowCrop;
        photoPreviewCell.scaleAspectFillCrop = _tzImagePickerVc.scaleAspectFillCrop;
        UICollectionView * _collectionView = [self valueForKey:@"collectionView"];
        __weak typeof(_tzImagePickerVc) weakTzImagePickerVc = _tzImagePickerVc;
        __weak typeof(_collectionView) weakCollectionView = _collectionView;
        __weak typeof(photoPreviewCell) weakCell = photoPreviewCell;
        [photoPreviewCell setImageProgressUpdateBlock:^(double progress) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            __strong typeof(weakTzImagePickerVc) strongTzImagePickerVc = weakTzImagePickerVc;
            __strong typeof(weakCollectionView) strongCollectionView = weakCollectionView;
            __strong typeof(weakCell) strongCell = weakCell;
            [strongSelf setValue:@(progress) forKey:@"progress"];
            //            strongSelf.progress = progress;
            if (progress >= 1) {
                if (strongSelf.isSelectOriginalPhoto) [strongSelf showPhotoBytes];
                __block  UIAlertController *alertView = [strongSelf valueForKey:@"alertView"];
                if (alertView && [strongCollectionView.visibleCells containsObject:strongCell]) {
                    [alertView dismissViewControllerAnimated:YES completion:^{
                        alertView = nil;
                        
                        [strongSelf performSelector:@selector(doneButtonClick)];
                    }];
                }
            }
        }];
        photoPreviewCell.previewView.iCloudSyncFailedHandle = ^(id asset, BOOL isSyncFailed) {
            model.iCloudFailed = isSyncFailed;
            [weakSelf performSelector:@selector(didICloudSyncStatusChanged:) withObject:model];
            [weakSelf.models replaceObjectAtIndex:indexPath.item withObject:model];
        };
    }
    
    cell.model = model;
    [cell setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf performSelector:@selector(didTapPreviewCell)];
        [strongSelf hideThumbCollectionView];
    }];
    
    return cell;
}

- (void)didICloudSyncStatusChanged:(TZAssetModel *)model{
    dispatch_async(dispatch_get_main_queue(), ^{
        TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
        // onlyReturnAsset为NO时,依赖TZ返回大图,所以需要有iCloud同步失败的提示,并且不能选择,
        if (_tzImagePickerVc.onlyReturnAsset) {
            return;
        }
        TZAssetModel *currentModel = self.models[self.currentIndex];
        UIButton *_doneButton = [self valueForKey:@"_doneButton"];
        if (_tzImagePickerVc.selectedModels.count <= 0) {
            
            _doneButton.enabled = !currentModel.iCloudFailed;
        } else {
            _doneButton.enabled = YES;
        }
        UIButton *_selectButton = [self valueForKey:@"_selectButton"];
        _selectButton.hidden = currentModel.iCloudFailed;
        UIButton *_originalPhotoButton = [self valueForKey:@"_originalPhotoButton"];
        _originalPhotoButton.hidden = currentModel.iCloudFailed;
        UILabel *_originalPhotoLabel = [self valueForKey:@"_originalPhotoLabel"];
        _originalPhotoLabel.hidden = currentModel.iCloudFailed;
        if (currentModel.type == TZAssetModelMediaTypeVideo) {
            _originalPhotoButton.hidden = YES;
            _originalPhotoLabel.hidden = YES;
        }else {
            _originalPhotoButton.hidden = NO;
            if (self.isSelectOriginalPhoto) { _originalPhotoLabel.hidden = NO;
            }else{
                _originalPhotoLabel.hidden = YES;
            }
        }
        [self resetBottomEnable];
    });
}

-(void)resetBottomEnable{
    TZAssetModel *model = self.models[self.currentIndex];
    JRImagePickerController *_tzImagePickerVc = (JRImagePickerController *)self.navigationController;
    BOOL flag = model.asset.duration > _tzImagePickerVc.videoLimitMaxDuration * 60 && _tzImagePickerVc.videoLimitMaxDuration > 0;
    UIButton *_selectButton = [self valueForKey:@"_selectButton"];
    _selectButton.enabled = !flag;
    UIButton *_originalPhotoButton = [self valueForKey:@"_originalPhotoButton"];
    _originalPhotoButton.enabled = !flag;
    UIButton * _doneButton = [self valueForKey:@"_doneButton"];
    if (flag && _tzImagePickerVc.selectedModels.count ==0) {
        _doneButton.enabled = NO;
    }else{
        _doneButton.enabled = YES;
    }
    
//    UIButton * _doneButton = [self valueForKey:@"_doneButton"];
//    if (_tzImagePickerVc.selectedModels.count == 0) {
//        _doneButton.enabled = NO;
//    }else{
//        _doneButton.enabled = YES;
//    }
}

-(void)hideThumbCollectionView{
    BOOL isHideNaviBar = [[self valueForKey:@"isHideNaviBar"] boolValue];
    TZImagePickerController * pickerController = (TZImagePickerController *)self.navigationController;
    
    self.thumbCollectionView.hidden = isHideNaviBar ;
    if ( pickerController.selectedModels.count == 0) {
        self.thumbCollectionView.hidden = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.width + 20);
    if (currentIndex < self.models.count && self.currentIndex != currentIndex) {
        self.currentIndex = currentIndex;
        [self performSelector:@selector(refreshNaviBarAndBottomBarState)];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoPreviewCollectionViewDidScroll" object:nil];
    [self.thumbCollectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TZPhotoPreviewCell class]]) {
        [(TZPhotoPreviewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TZPhotoPreviewCell class]]) {
        [(TZPhotoPreviewCell *)cell recoverSubviews];
    } else if ([cell isKindOfClass:[TZVideoPreviewCell class]]) {
        TZVideoPreviewCell *videoCell = (TZVideoPreviewCell *)cell;
        if (videoCell.player && videoCell.player.rate != 0.0) {
            [videoCell pausePlayerAndShowNaviBar];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.thumbCollectionView]) {
        TZImagePickerController * pickerController = (TZImagePickerController *)self.navigationController;
        NSArray * dataArray = self.onlyShowSelectModel ? self.models : pickerController.selectedModels;
        TZAssetModel * tapModel = [dataArray objectAtIndex:indexPath.row];
        for (TZAssetModel * model in self.models) {
            if ([tapModel.asset isEqual:model.asset]) {
                self.currentIndex = [self.models indexOfObject:model];
                break;
            }
        }
        UICollectionView * mainCollectionView = [self valueForKey:@"collectionView"];
        [mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]  atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}


- (void)refreshNaviBarAndBottomBarState {
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    //取父类属性
    NSMutableArray *_models = [self valueForKey:@"_models"];
    TZAssetModel *model = _models[self.currentIndex];
    UIButton *_selectButton = [self valueForKey:@"_selectButton"];
     UILabel *_indexLabel = [self valueForKey:@"_indexLabel"];
     UILabel *_numberLabel = [self valueForKey:@"_numberLabel"];
    UIImageView *_numberImageView = [self valueForKey:@"_numberImageView"];
    BOOL _isHideNaviBar = [[self valueForKey:@"isHideNaviBar"] boolValue];
    UIButton *_originalPhotoButton = [self valueForKey:@"_originalPhotoButton"];
     UILabel *_originalPhotoLabel = [self valueForKey:@"_originalPhotoLabel"];
    UIView *_naviBar = [self valueForKey:@"_naviBar"];
    UIButton *_doneButton= [self valueForKey:@"_doneButton"];
     UICollectionView *_collectionView= [self valueForKey:@"_collectionView"];
     UIButton *_backButton = [self valueForKey:@"_backButton"];
    UIView *_toolBar = [self valueForKey:@"_toolBar"];
    
    _selectButton.selected = model.isSelected;
    [self refreshSelectButtonImageViewContentMode];
    if (_selectButton.isSelected && _tzImagePickerVc.showSelectedIndex && _tzImagePickerVc.showSelectBtn) {
        NSString *index = [NSString stringWithFormat:@"%d", (int)([_tzImagePickerVc.selectedAssetIds indexOfObject:model.asset.localIdentifier] + 1)];
        _indexLabel.text = index;
        _indexLabel.hidden = NO;
    } else {
        _indexLabel.hidden = YES;
    }
    _numberLabel.text = [NSString stringWithFormat:@"%zd",_tzImagePickerVc.selectedModels.count];
    _numberImageView.hidden = (_tzImagePickerVc.selectedModels.count <= 0 || _isHideNaviBar || self.isCropImage);
    _numberLabel.hidden = (_tzImagePickerVc.selectedModels.count <= 0 || _isHideNaviBar || self.isCropImage);
    
    _originalPhotoButton.selected = self.isSelectOriginalPhoto;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
    if (self.isSelectOriginalPhoto) [self showPhotoBytes];
    
    // If is previewing video, hide original photo button
    // 如果正在预览的是视频，隐藏原图按钮
    if (!_isHideNaviBar) {
        if (model.type == TZAssetModelMediaTypeVideo) {
            _originalPhotoButton.hidden = YES;
            _originalPhotoLabel.hidden = YES;
        } else {
            _originalPhotoButton.hidden = NO;
            if (self.isSelectOriginalPhoto) { _originalPhotoLabel.hidden = NO;
            }else{
                _originalPhotoLabel.hidden = YES;
            }
        }
    }
    
    _doneButton.hidden = NO;
    _selectButton.hidden = !_tzImagePickerVc.showSelectBtn;
    // 让宽度/高度小于 最小可选照片尺寸 的图片不能选中
    if (![[TZImageManager manager] isPhotoSelectableWithAsset:model.asset]) {
        _numberLabel.hidden = YES;
        _numberImageView.hidden = YES;
        _selectButton.hidden = YES;
        _originalPhotoButton.hidden = YES;
        _originalPhotoLabel.hidden = YES;
        _doneButton.hidden = YES;
    }
    
    //当前是视频不显示原图按钮
    
    
    // iCloud同步失败的UI刷新
    [self didICloudSyncStatusChanged:model];
    
 
    
    if (_tzImagePickerVc.photoPreviewPageDidRefreshStateBlock) {
        _tzImagePickerVc.photoPreviewPageDidRefreshStateBlock(_collectionView, _naviBar, _backButton, _selectButton, _indexLabel, _toolBar, _originalPhotoButton, _originalPhotoLabel, _doneButton, _numberImageView, _numberLabel);
       
    }
   
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
