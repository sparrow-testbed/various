//
//  JRPhotoPickerController.m
//  JRPodPrivate_Example
//
//  Created by 金煜祥 on 2020/9/21.
//  Copyright © 2020 wni. All rights reserved.
//

#import "JRPhotoPickerController.h"
#import "JRAssetCell.h"
#import "JRPhotoPreviewController.h"
#import "UIView+TZLayout.h"
#import "JRImagePickerController.h"
#define AlbumCellHeight 64.0

@interface JRPhotoPickerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIButton * titleButton;
@property (nonatomic,strong)NSMutableArray * albumArr;
@property (nonatomic,strong)TZImagePickerController *tzImagePickerVc;
@end

@implementation JRPhotoPickerController
{
    //    NSMutableArray *_albumArr;
    UITableView *_tableView;
    UIView * _tableViewBGView;
    BOOL _showTableView;
    NSInteger _albumSelectIndex;
    UIImageView * projectiveView;
}
- (void)dealloc
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_titleButton setTitle:@"最近项目" forState:UIControlStateNormal];
    _titleButton.bounds = CGRectMake(0, 0, 200, 32);
    
    [_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    _titleButton.titleLabel.font = [UIFont fontWithName:@"PingFangTC-Medium" size:18];
    _titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleButton setImage:[JRUIHelper imageNamed:@"title_arrow"] forState:UIControlStateNormal];
    [_titleButton jk_setImagePosition:LXMImagePositionRight spacing:8];
    [_titleButton addTarget:self action:@selector(choseAlbum:) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.titleView = _titleButton;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;
    _tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:_tzImagePickerVc action:@selector(cancelButtonClick)];
    
    _tableViewBGView = [[UIView alloc]initWithFrame:self.view.bounds];
    _tableViewBGView.backgroundColor = [UIColor jk_colorWithHex:0x000000 andAlpha:0];
    _tableViewBGView.frame = CGRectMake(0, NaviHeight, self.view.bounds.size.width,self.view.bounds.size.height-NaviHeight);
    
    [_tzImagePickerVc.view addSubview:_tableViewBGView];
    _tableViewBGView.hidden = YES;
    _showTableView = NO;
    
    _albumSelectIndex = 0;
    [self layoutTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange:)name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
//    TZCollectionView *collectionView = [self valueForKey:@"collectionView"];
//    //设置collectionViewItem 间距
//      CGFloat kMagin = 2;
//      UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
//      CGFloat itemWidth = (SCREEN_WIDTH - 3 * kMagin - 10) / 4;
//
//      flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
//
//      flowLayout.minimumLineSpacing = kMagin;
//      flowLayout.minimumInteritemSpacing = kMagin;
//      collectionView.collectionViewLayout = flowLayout;
    // Do any additional setup after loading the view.
}

//- (void)configCollectionView {
//     TZCollectionView *_collectionView = [self valueForKey:@"collectionView"];
//    if (!_collectionView) {
//        UICollectionViewFlowLayout * _layout = [self valueForKey:@"layout"];
//        _layout = [[UICollectionViewFlowLayout alloc] init];
//        //设置collectionViewItem 间距
//        CGFloat kMagin = 2;
//
//        CGFloat itemWidth = (SCREEN_WIDTH - 3 * kMagin - 10) / 4;
//
//        _layout.itemSize = CGSizeMake(itemWidth, itemWidth);
//
//        _layout.minimumLineSpacing = kMagin;
//        _layout.minimumInteritemSpacing = kMagin;
//
//        _collectionView = [[TZCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
//        if (@available(iOS 13.0, *)) {
//            _collectionView.backgroundColor = UIColor.tertiarySystemBackgroundColor;
//        } else {
//            _collectionView.backgroundColor = [UIColor whiteColor];
//        }
//        _collectionView.dataSource = self;
//        _collectionView.delegate = self;
//        _collectionView.alwaysBounceHorizontal = NO;
////        _collectionView.contentInset = UIEdgeInsetsMake(itemMargin, itemMargin, itemMargin, itemMargin);
//        [self.view addSubview:_collectionView];
//        [_collectionView registerClass:[TZAssetCell class] forCellWithReuseIdentifier:@"TZAssetCell"];
//        [_collectionView registerClass:[TZAssetCameraCell class] forCellWithReuseIdentifier:@"TZAssetCameraCell"];
//    } else {
//        [_collectionView reloadData];
//    }
//
//    BOOL _showTakePhotoBtn = [[self valueForKey:@"_showTakePhotoBtn"]boolValue];
//    if (_showTakePhotoBtn) {
//        _collectionView.contentSize = CGSizeMake(self.view.tz_width, ((self.model.count + self.columnNumber) / self.columnNumber) * self.view.tz_width);
//    } else {
//        _collectionView.contentSize = CGSizeMake(self.view.tz_width, ((self.model.count + self.columnNumber - 1) / self.columnNumber) * self.view.tz_width);
//        UILabel *_noDataLabel = [self valueForKey:@"noDataLabel"];
//        NSMutableArray * _models = [self valueForKey:@"_models"];
//        if (_models.count == 0) {
//            _noDataLabel = [UILabel new];
//            _noDataLabel.textAlignment = NSTextAlignmentCenter;
//            _noDataLabel.text = [NSBundle tz_localizedStringForKey:@"No Photos or Videos"];
//            CGFloat rgb = 153 / 256.0;
//            _noDataLabel.textColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
//            _noDataLabel.font = [UIFont boldSystemFontOfSize:20];
//            [_collectionView addSubview:_noDataLabel];
//        } else if (_noDataLabel) {
//            [_noDataLabel removeFromSuperview];
//            _noDataLabel = nil;
//        }
//    }
//}

-(void)OrientationDidChange:(id)sender{
    _tableViewBGView.frame = CGRectMake(0, NaviHeight, self.view.bounds.size.width,self.view.bounds.size.height-NaviHeight);
    if (_showTableView) {
        
        [self showTableView];
    }else{
        [self hideTableView];
    }
}

-(void)layoutTableView{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __weak typeof(self) _self = self;
        [[TZImageManager manager] getAllAlbums:self.tzImagePickerVc.allowPickingVideo allowPickingImage:self.tzImagePickerVc.allowPickingImage needFetchAssets:YES completion:^(NSArray<TZAlbumModel *> *models) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(_self) self = _self;
                self->_albumArr = [NSMutableArray arrayWithArray:models];
                for (TZAlbumModel *albumModel in self->_albumArr) {
                    albumModel.selectedModels = _tzImagePickerVc.selectedModels;
                }
                TZAlbumModel * model = [self->_albumArr firstObject];
                model.name = @"最近项目";
                
                if (self.isFirstAppear) {
                    self.isFirstAppear = NO;
                    [self layoutTableView];
                }
                if (!self->_tableView) {
                    self->_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                    self->_tableView.rowHeight = AlbumCellHeight;
                    self->_tableView.backgroundColor = [UIColor whiteColor];
                    self->_tableView.tableFooterView = [[UIView alloc] init];
                    self->_tableView.dataSource = self;
                    self->_tableView.delegate = self;
                    [self->_tableView registerClass:[TZAlbumCell class] forCellReuseIdentifier:@"TZAlbumCell"];
                    [self->_tableViewBGView addSubview:self->_tableView];
                    self->_tableView.frame = CGRectMake(0, 0, self->_tableViewBGView.bounds.size.width,0);
                } else {
                    [self->_tableView reloadData];
                }
            });
        }];
    });
}
- (void)getSelectedPhotoBytes {
    // 越南语 && 5屏幕时会显示不下，暂时这样处理
    if ([[TZImagePickerConfig sharedInstance].preferredLanguage isEqualToString:@"vi"] && self.view.jk_width <= 320) {
        return;
    }
    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
    __weak typeof(self) _self = self;
    [[TZImageManager manager] getPhotosBytesWithArray:imagePickerVc.selectedModels completion:^(NSString *totalBytes) {
        __strong typeof(_self) self = _self;
        UILabel * orPhotoLabel = [self valueForKey:@"_originalPhotoLabel"];
        if (![totalBytes isEqualToString:@"0B"]) {
            orPhotoLabel.text =[NSString stringWithFormat:@"(共%@)",totalBytes];
        }else{
            orPhotoLabel.text = @"";
        }
    }];
}

#pragma mark -UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    BOOL _showTakePhotoBtn = [[self valueForKey:@"_showTakePhotoBtn"] boolValue];
    NSMutableArray *_models = [self valueForKey:@"_models"];
    if (_showTakePhotoBtn) {
        return _models.count + 1;
    }
    return _models.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // the cell lead to take a picture / 去拍照的cell
    [collectionView registerClass:[JRAssetCell class] forCellWithReuseIdentifier:@"JRAssetCell"];
    JRImagePickerController *tzImagePickerVc = (JRImagePickerController *)self.navigationController;
    NSMutableArray *_models = [self valueForKey:@"_models"];
    BOOL _showTakePhotoBtn = [[self valueForKey:@"_showTakePhotoBtn"] boolValue];
    if (((tzImagePickerVc.sortAscendingByModificationDate && indexPath.item >= _models.count) || (!tzImagePickerVc.sortAscendingByModificationDate && indexPath.item == 0)) && _showTakePhotoBtn) {
        TZAssetCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZAssetCameraCell" forIndexPath:indexPath];
        cell.imageView.image = tzImagePickerVc.takePictureImage;
        if ([tzImagePickerVc.takePictureImageName isEqualToString:@"takePicture80"]) {
            cell.imageView.contentMode = UIViewContentModeCenter;
            CGFloat rgb = 223 / 255.0;
            cell.imageView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
        } else {
            cell.imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        }
        return cell;
    }
    // the cell dipaly photo or video / 展示照片或视频的cell
    
    JRAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JRAssetCell" forIndexPath:indexPath];
    cell.allowPickingMultipleVideo = tzImagePickerVc.allowPickingMultipleVideo;
    cell.photoDefImage = tzImagePickerVc.photoDefImage;
    cell.photoSelImage = tzImagePickerVc.photoSelImage;
    cell.assetCellDidSetModelBlock = tzImagePickerVc.assetCellDidSetModelBlock;
    cell.assetCellDidLayoutSubviewsBlock = tzImagePickerVc.assetCellDidLayoutSubviewsBlock;
    cell.videoLimitMaxDuration = tzImagePickerVc.videoLimitMaxDuration;
    TZAssetModel *model;
    if (tzImagePickerVc.sortAscendingByModificationDate || !_showTakePhotoBtn) {
        model = _models[indexPath.item];
    } else {
        model = _models[indexPath.item - 1];
    }
    cell.allowPickingGif = tzImagePickerVc.allowPickingGif;
    cell.model = model;

    if (model.isSelected && tzImagePickerVc.showSelectedIndex) {
        cell.index = [tzImagePickerVc.selectedAssetIds indexOfObject:model.asset.localIdentifier] + 1;
    }
    cell.showSelectBtn = tzImagePickerVc.showSelectBtn;
    cell.allowPreview = tzImagePickerVc.allowPreview;
    
    if (tzImagePickerVc.selectedModels.count >= tzImagePickerVc.maxImagesCount && tzImagePickerVc.showPhotoCannotSelectLayer && !model.isSelected) {
        cell.cannotSelectLayerButton.backgroundColor = tzImagePickerVc.cannotSelectLayerColor;
        cell.cannotSelectLayerButton.hidden = NO;
    } else {
        cell.cannotSelectLayerButton.hidden = YES;
    }
    
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    UIImageView *_numberImageView = [self valueForKey:@"_numberImageView"];
    __weak typeof(_numberImageView.layer) weakLayer = _numberImageView.layer;
    cell.didSelectPhotoBlock = ^(BOOL isSelected) {
        __strong typeof(weakCell) strongCell = weakCell;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakLayer) strongLayer = weakLayer;
        TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)strongSelf.navigationController;
        // 1. cancel select / 取消选择
        if (isSelected) {
            strongCell.selectPhotoButton.selected = NO;
            model.isSelected = NO;
            NSArray *selectedModels = [NSArray arrayWithArray:tzImagePickerVc.selectedModels];
            for (TZAssetModel *model_item in selectedModels) {
                if ([model.asset.localIdentifier isEqualToString:model_item.asset.localIdentifier]) {
                    [tzImagePickerVc removeSelectedModel:model_item];
                    break;
                }
            }
            [strongSelf performSelector:@selector(refreshBottomToolBarStatus)];
            if (tzImagePickerVc.showSelectedIndex || tzImagePickerVc.showPhotoCannotSelectLayer) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TZ_PHOTO_PICKER_RELOAD_NOTIFICATION" object:strongSelf.navigationController];
            }
            [UIView showOscillatoryAnimationWithLayer:strongLayer type:TZOscillatoryAnimationToSmaller];
            if (strongCell.model.iCloudFailed) {
                NSMutableArray *_models = [strongSelf valueForKey:@"_models"];
                [_models replaceObjectAtIndex:indexPath.item withObject:strongCell.model];
                NSString *title = [NSBundle tz_localizedStringForKey:@"iCloud sync failed"];
                [tzImagePickerVc showAlertWithTitle:title];
            }
        } else {
            // 2. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
            if (tzImagePickerVc.selectedModels.count < tzImagePickerVc.maxImagesCount) {
                if (!tzImagePickerVc.allowPreview) {
                    BOOL shouldDone = tzImagePickerVc.maxImagesCount == 1;
                    if (!tzImagePickerVc.allowPickingMultipleVideo && (model.type == TZAssetModelMediaTypeVideo || model.type == TZAssetModelMediaTypePhotoGif)) {
                        shouldDone = YES;
                    }
                    if (shouldDone) {
                        model.isSelected = YES;
                        [tzImagePickerVc addSelectedModel:model];
                        [strongSelf performSelector:@selector(doneButtonClick)];
                        return;
                    }
                }
                strongCell.selectPhotoButton.selected = YES;
                model.isSelected = YES;
                [tzImagePickerVc addSelectedModel:model];
                if (tzImagePickerVc.showSelectedIndex || tzImagePickerVc.showPhotoCannotSelectLayer) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TZ_PHOTO_PICKER_RELOAD_NOTIFICATION" object:strongSelf.navigationController];
                }
                [strongSelf performSelector:@selector(refreshBottomToolBarStatus)];
                [UIView showOscillatoryAnimationWithLayer:strongLayer type:TZOscillatoryAnimationToSmaller];
            } else {
                NSString *title = [NSString stringWithFormat:@"最多可选%zd张", tzImagePickerVc.maxImagesCount];
                [tzImagePickerVc showAlertWithTitle:title];
            }
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // take a photo / 去拍照
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    BOOL _showTakePhotoBtn = [[self valueForKey:@"_showTakePhotoBtn"] boolValue];
      NSMutableArray *_models = [self valueForKey:@"_models"];
    if (((tzImagePickerVc.sortAscendingByModificationDate && indexPath.item >= _models.count) || (!tzImagePickerVc.sortAscendingByModificationDate && indexPath.item == 0)) && _showTakePhotoBtn)  {
        [self performSelector:@selector(takePhoto)]; return;
    }
    // preview phote or video / 预览照片或视频
    NSInteger index = indexPath.item;
    if (!tzImagePickerVc.sortAscendingByModificationDate && _showTakePhotoBtn) {
        index = indexPath.item - 1;
    }
    TZAssetModel *model = _models[index];
    if (model.type == TZAssetModelMediaTypeVideo && !tzImagePickerVc.allowPickingMultipleVideo) {
        if (tzImagePickerVc.selectedModels.count > 0) {
            TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
            [imagePickerVc showAlertWithTitle:[NSBundle tz_localizedStringForKey:@"Can not choose both video and photo"]];
        } else {
            TZVideoPlayerController *videoPlayerVc = [[TZVideoPlayerController alloc] init];
            videoPlayerVc.model = model;
            [self.navigationController pushViewController:videoPlayerVc animated:YES];
        }
    } else if (model.type == TZAssetModelMediaTypePhotoGif && tzImagePickerVc.allowPickingGif && !tzImagePickerVc.allowPickingMultipleVideo) {
        if (tzImagePickerVc.selectedModels.count > 0) {
            TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
            [imagePickerVc showAlertWithTitle:[NSBundle tz_localizedStringForKey:@"Can not choose both photo and GIF"]];
        } else {
            TZGifPhotoPreviewController *gifPreviewVc = [[TZGifPhotoPreviewController alloc] init];
            gifPreviewVc.model = model;
            [self.navigationController pushViewController:gifPreviewVc animated:YES];
        }
    } else {
        TZPhotoPreviewController *photoPreviewVc = [[TZPhotoPreviewController alloc] init];
        photoPreviewVc.currentIndex = index;
        photoPreviewVc.models = _models;
        JRAssetCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        projectiveView = [cell valueForKey:@"imageView"];
        [self pushPhotoPrevireViewController:photoPreviewVc];
    }
}

#pragma mark - UITableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TZAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZAlbumCell"];
    __weak typeof(cell) weakCell = cell;
    cell.albumCellDidLayoutSubviewsBlock = ^(TZAlbumCell *cell, UIImageView *posterImageView, UILabel *titleLabel) {
        posterImageView.frame = CGRectMake(0, 0, AlbumCellHeight, AlbumCellHeight);
        titleLabel.textColor = [UIColor colorWithHex:@"#16181A"];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.text = [NSString stringWithFormat:@"%@ (%ld)",weakCell.model.name,(long)weakCell.model.count];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(posterImageView.mas_right).offset(20);
            make.centerY.equalTo(posterImageView.mas_centerY);
        }];
    };
    
    cell.model = _albumArr[indexPath.row];
    
    cell.selectedCountButton.hidden = YES;
    UIImageView * selecetImageView = (UIImageView *)[cell.contentView viewWithTag:101];
    if (selecetImageView) {
        selecetImageView.hidden = !(indexPath.row == _albumSelectIndex);
    }else{
        UIImageView * selecetImageView = [[UIImageView alloc]initWithImage:[JRUIHelper imageNamed:@"album_select_flag"]];
        selecetImageView.tag = 101;
        [cell.contentView addSubview:selecetImageView];
        [selecetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-16);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
        selecetImageView.hidden = !(indexPath.row == _albumSelectIndex);
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TZAlbumModel *model = _albumArr[indexPath.row];
    
    [_titleButton setTitle:model.name forState:UIControlStateNormal];
    self.model = model;
    _albumSelectIndex = indexPath.row;
    //切换相册，标注选中
    for (TZAssetModel * model in self.model.models) {
        model.isSelected = NO;
        for (TZAssetModel * tempModel in self.model.selectedModels) {
            if ([model.asset.localIdentifier isEqualToString:tempModel.asset.localIdentifier]) {
                model.isSelected = YES;
                break;
            }
        }
    }
    [self setValue:[NSMutableArray arrayWithArray:self.model.models] forKey:@"_models"] ;
    
    UICollectionView * collectionView = [self valueForKey:@"_collectionView"];
    [collectionView reloadData];
    [self choseAlbum:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadData];

    [self setValue:@(YES) forKey:@"_shouldScrollToBottom"];
    [self scrollCollectionViewToBottom];
}


-(void)choseAlbum:(id)sender{
    
    _showTableView = !_showTableView;
    if (_showTableView) {
        [_titleButton setImage:[[JRUIHelper imageNamed:@"title_arrow"] jk_flipVertical] forState:UIControlStateNormal];
        [self showTableView];
        [_tableView reloadData];
    }else{
        [_titleButton setImage:[JRUIHelper imageNamed:@"title_arrow"] forState:UIControlStateNormal];
        [self hideTableView];
    }
    
    //重新更新button文字与图片的间距
    //    CGFloat space = self.model.name.length > 2 ? 8 : 20;
    [_titleButton jk_setImagePosition:LXMImagePositionRight spacing:8];
}

-(void)showTableView{
    _tableViewBGView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self->_tableView.frame = CGRectMake(0, 0, self->_tableViewBGView.bounds.size.width, self->_albumArr.count * AlbumCellHeight < AlbumCellHeight * 8?self->_albumArr.count * AlbumCellHeight:AlbumCellHeight * 8);
//        self->_tableView.frame = CGRectMake(0, 0, self->_tableViewBGView.bounds.size.width, self->_albumArr.count * AlbumCellHeight < self->_tableViewBGView.bounds.size.height?self->_albumArr.count * AlbumCellHeight:self->_tableViewBGView.bounds.size.height);
        self->_tableViewBGView.backgroundColor = [UIColor jk_colorWithHex:0x000000 andAlpha:0.7];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideTableView{
    [UIView animateWithDuration:0.3 animations:^{
        self->_tableViewBGView.backgroundColor = [UIColor jk_colorWithHex:0x000000 andAlpha:0];
        self->_tableView.frame = CGRectMake(0, 0, self->_tableViewBGView.bounds.size.width,0);
    } completion:^(BOOL finished) {
        self->_tableViewBGView.hidden = YES;
    }];
}

- (void)previewButtonClick {
    JRPhotoPreviewController *photoPreviewVc = [[JRPhotoPreviewController alloc] init];
    photoPreviewVc.onlyShowSelectModel = YES;
    [self pushPhotoPrevireViewController:photoPreviewVc needCheckSelectedModels:YES];
}

- (void)pushPhotoPrevireViewController:(TZPhotoPreviewController *)photoPreviewVc {
    JRPhotoPreviewController * jrPhotoPreviewVc = [[JRPhotoPreviewController alloc]init];
    jrPhotoPreviewVc.models = photoPreviewVc.models;
    jrPhotoPreviewVc.currentIndex = photoPreviewVc.currentIndex;
    [self pushPhotoPrevireViewController:photoPreviewVc needCheckSelectedModels:NO];
}

- (void)pushPhotoPrevireViewController:(JRPhotoPreviewController *)photoPreviewVc needCheckSelectedModels:(BOOL)needCheckSelectedModels {
    JRPhotoPreviewController * jrPhotoPreviewVc = [[JRPhotoPreviewController alloc]init];
    jrPhotoPreviewVc.models = photoPreviewVc.models;
    jrPhotoPreviewVc.currentIndex = photoPreviewVc.currentIndex;
    if ([photoPreviewVc isKindOfClass:[JRPhotoPreviewController class]]) {
        jrPhotoPreviewVc.onlyShowSelectModel = photoPreviewVc.onlyShowSelectModel;
    }
    
    __weak typeof(self) weakSelf = self;
    jrPhotoPreviewVc.isSelectOriginalPhoto = [[self valueForKey:@"isSelectOriginalPhoto"] boolValue] ;
    [jrPhotoPreviewVc setBackButtonClickBlock:^(BOOL isSelectOriginalPhoto) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [strongSelf setValue:@(isSelectOriginalPhoto) forKey:@"isSelectOriginalPhoto"];
        if (needCheckSelectedModels) {
            [strongSelf performSelector:@selector(checkSelectedModels)];
        }
        UICollectionView * collectionView = [strongSelf valueForKey:@"collectionView"];
        [collectionView reloadData];
        [strongSelf performSelector:@selector(refreshBottomToolBarStatus)];
        
    }];
    [jrPhotoPreviewVc setDoneButtonClickBlock:^(BOOL isSelectOriginalPhoto) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        //        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [strongSelf setValue:@(isSelectOriginalPhoto) forKey:@"isSelectOriginalPhoto"];
        [strongSelf performSelector:@selector(doneButtonClick)];
    }];
    [jrPhotoPreviewVc setDoneButtonClickBlockCropMode:^(UIImage *cropedImage, id asset) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf didGetAllPhotos:@[cropedImage] assets:@[asset] infoArr:nil];
    }];
    if (!jrPhotoPreviewVc.onlyShowSelectModel) {
        
        UIImageView *animateImageView = [self imageViewAssimilateToView:projectiveView];
        animateImageView.frame = [projectiveView convertRect:projectiveView.bounds toView:self.view];
        animateImageView.image = projectiveView.image;
        
        [self.view addSubview:animateImageView];

        [UIView animateWithDuration:0.3 animations:^{
            animateImageView.frame = self.view.frame;

        } completion:^(BOOL finished) {
            // Disappear smoothly.
            [self.navigationController pushViewController:jrPhotoPreviewVc animated:NO];
            [animateImageView removeFromSuperview];

        }];
    }else{
        [self.navigationController pushViewController:jrPhotoPreviewVc animated:YES];
    }
    
}
- (UIImageView *)imageViewAssimilateToView:(nullable __kindof UIView *)view {
    UIImageView *animateImageView = [UIImageView new];
    animateImageView.contentMode = UIViewContentModeScaleAspectFit;
    animateImageView.layer.masksToBounds = view.layer.masksToBounds;
    animateImageView.layer.cornerRadius = view.layer.cornerRadius;
    animateImageView.layer.backgroundColor = [UIColor blackColor].CGColor;// view.layer.backgroundColor;
    return animateImageView;
}

- (void)didGetAllPhotos:(NSArray *)photos assets:(NSArray *)assets infoArr:(NSArray *)infoArr {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    [tzImagePickerVc hideProgressHUD];
    UIButton * doneButton = [self valueForKey:@"_doneButton"];
    doneButton.enabled = YES;
    
    if (tzImagePickerVc.autoDismiss) {
        __weak typeof(self) _self = self;
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            __strong typeof(_self) self = _self;
            [self callDelegateMethodWithPhotos:photos assets:assets infoArr:infoArr];
        }];
    } else {
        [self callDelegateMethodWithPhotos:photos assets:assets infoArr:infoArr];
    }
}

- (void)callDelegateMethodWithPhotos:(NSArray *)photos assets:(NSArray *)assets infoArr:(NSArray *)infoArr {
    BOOL _isSelectOriginalPhoto =[[self valueForKey:@"_isSelectOriginalPhoto"] boolValue];
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    if (tzImagePickerVc.allowPickingVideo && tzImagePickerVc.maxImagesCount == 1) {
        if ([[TZImageManager manager] isVideo:[assets firstObject]]) {
            if ([tzImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingVideo:sourceAssets:)]) {
                [tzImagePickerVc.pickerDelegate imagePickerController:tzImagePickerVc didFinishPickingVideo:[photos firstObject] sourceAssets:[assets firstObject]];
            }
            if (tzImagePickerVc.didFinishPickingVideoHandle) {
                tzImagePickerVc.didFinishPickingVideoHandle([photos firstObject], [assets firstObject]);
            }
            return;
        }
    }
    
    if ([tzImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
        [tzImagePickerVc.pickerDelegate imagePickerController:tzImagePickerVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto];
    }
    if ([tzImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:infos:)]) {
        [tzImagePickerVc.pickerDelegate imagePickerController:tzImagePickerVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto infos:infoArr];
    }
    if (tzImagePickerVc.didFinishPickingPhotosHandle) {
        tzImagePickerVc.didFinishPickingPhotosHandle(photos,assets,_isSelectOriginalPhoto);
    }
    if (tzImagePickerVc.didFinishPickingPhotosWithInfosHandle) {
        tzImagePickerVc.didFinishPickingPhotosWithInfosHandle(photos,assets,_isSelectOriginalPhoto,infoArr);
    }
}


- (void)scrollCollectionViewToBottom {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    __block BOOL _shouldScrollToBottom = [[self valueForKey:@"_shouldScrollToBottom"] boolValue];
    NSMutableArray *_models = [self valueForKey:@"_models"];
    BOOL _showTakePhotoBtn = [[self valueForKey:@"_showTakePhotoBtn"] boolValue];
    
    __block TZCollectionView * _collectionView = [self valueForKey:@"collectionView"];
    if (_shouldScrollToBottom && _models.count > 0) {
        NSInteger item = 0;
        if (tzImagePickerVc.sortAscendingByModificationDate) {
            item = _models.count - 1;
            if (_showTakePhotoBtn) {
                item += 1;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            _shouldScrollToBottom = NO;
            [self setValue:@(NO) forKey:@"_shouldScrollToBottom"];
            _collectionView.hidden = NO;
        });
        
    } else {
        _collectionView.hidden = NO;
    }
}

- (void)refreshBottomToolBarStatus {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    UIButton * _previewButton = [self valueForKey:@"_previewButton"];
    UIButton * _doneButton = [self valueForKey:@"_doneButton"];
    UIImageView *_numberImageView = [self valueForKey:@"_numberImageView"];
    UILabel *_numberLabel = [self valueForKey:@"_numberLabel"];
    UIButton *_originalPhotoButton = [self valueForKey:@"_originalPhotoButton"];
    UILabel *_originalPhotoLabel = [self valueForKey:@"_originalPhotoLabel"];
    BOOL _isSelectOriginalPhoto = [[self valueForKey:@"isSelectOriginalPhoto"] boolValue];
    
    UIView *_bottomToolBar = [self valueForKey:@"_bottomToolBar"];
    UIView *_divideLine= [self valueForKey:@"_divideLine"];
    TZCollectionView *_collectionView = [self valueForKey:@"collectionView"];
    _previewButton.enabled = tzImagePickerVc.selectedModels.count > 0;
    _doneButton.enabled = tzImagePickerVc.selectedModels.count > 0 || tzImagePickerVc.alwaysEnableDoneBtn;
    
    _numberImageView.hidden = tzImagePickerVc.selectedModels.count <= 0;
    _numberLabel.hidden = tzImagePickerVc.selectedModels.count <= 0;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",tzImagePickerVc.selectedModels.count];
    
    _originalPhotoButton.enabled = tzImagePickerVc.selectedModels.count > 0;
    
    _originalPhotoButton.selected = _isSelectOriginalPhoto;
    _originalPhotoLabel.hidden = (!_originalPhotoButton.isSelected);
    if (_isSelectOriginalPhoto) [self getSelectedPhotoBytes];
    
    if (tzImagePickerVc.photoPickerPageDidRefreshStateBlock) {
        tzImagePickerVc.photoPickerPageDidRefreshStateBlock(_collectionView, _bottomToolBar, _previewButton, _originalPhotoButton, _originalPhotoLabel, _doneButton, _numberImageView, _numberLabel, _divideLine);;
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
