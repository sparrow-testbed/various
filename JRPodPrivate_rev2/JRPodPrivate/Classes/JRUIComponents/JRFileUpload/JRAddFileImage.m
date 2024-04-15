//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/1/15
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#define imageH 74 // 图片高度
#define imageW 74 // 图片宽度
#define kFileH 30 // 文件内容高度
#define kMaxColumn 4 //每行显示数量
#define kMargin 9 // 边距
#define kSectionSpace 10

#define kTitleLeft 20
#define kCollectionViewRight 15
#define MainScreenWidth [[UIScreen mainScreen]bounds].size.width
#define MainScreenHeight [[UIScreen mainScreen]bounds].size.height

#define kScaleX MainScreenWidth/355.0
#define kScaleY MainScreenHeight/667.0

#define kScale MainScreenHeight/MainScreenWidth


#import "JRAddFileImage.h"
#import "JRUIKit.h"
#import "JRImageUploadModel.h"

#import "JRBlankFootCollectionReusableView.h"
@interface JRAddFileImage ()<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    float _itemWH;
}
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) JRUIButton *subCommitButton;
@property (nonatomic ,strong) UIView *contentView;
@property (nonatomic ,strong) UIView *subCommitbagView;
@property (strong, nonatomic) TZPhotoPreviewView *previewView;
@end


@implementation JRAddFileImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:@"#F2F5F4"];
        //容器视图
        self.contentView = [[UIView alloc]init];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        // 注册cell
        [self.collectionView registerClass:[JRImageCollectionViewCell class] forCellWithReuseIdentifier:@"JRImageCollectionViewCell"];
        [self.collectionView registerClass:[JRFileCollectionViewCell class] forCellWithReuseIdentifier:@"JRFileCollectionViewCell"];
        [self.collectionView registerClass:[JRBlankFootCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
        //提交按钮
        self.subCommitbagView = [[UIView alloc]init];
        self.subCommitbagView.backgroundColor = [UIColor colorWithHex:@"#F2F5F4"];
        //添加子视图
        [self addSubview:self.mainScrollView];
        [self.mainScrollView addSubview:self.contentView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.collectionView];
        // 提交按钮需要配置
        [self.contentView addSubview:self.subCommitbagView];
        [self.subCommitbagView addSubview:self.subCommitButton];
        
        //
        self.max = 0;
            
    }
    return self;
}

// 对所有子控件进行布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainScrollView);
        make.width.equalTo(self.mainScrollView);
    }];

    CGSize size = CGSizeMake(MAXFLOAT, 45);
    [_titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]} context:nil];
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    _titleLabel.attributedText = titleStr;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(23);
        make.left.mas_equalTo(kTitleLeft);
    }];

    // 如果有 子 title
    if (self.subTitleLabel.text.length>0) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.subTitleLabel.text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
        _subTitleLabel.attributedText = string;
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
            make.top.equalTo(self.titleLabel.mas_top).offset(20);
            make.right.equalTo(self.mas_right).offset(-kCollectionViewRight);
            make.height.mas_equalTo(@([self getConllectionHeight]));
        }];
    }else {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
            make.top.equalTo(self.titleLabel.mas_top).offset(-10);
            make.right.equalTo(self.mas_right).offset(-kCollectionViewRight);
            make.height.mas_equalTo(@([self getConllectionHeight]));
        }];
    }
    
    //高度自适应 这里会修改contentSize
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.collectionView.mas_bottom).offset(150);
    }];
    
    if (self.isVisable) { //这里配置是否显示提交按钮
        self.subCommitbagView.hidden = YES;
    }else {
        self.subCommitbagView.hidden = NO;
    }
    
    [self.subCommitbagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];

    [self.subCommitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subCommitbagView.mas_top).offset(20);
        make.width.equalTo(@160);
        make.height.equalTo(@48);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
}

#pragma mark - lazy method

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;;
}

- (UILabel *)subTitleLabel {
    if (_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = [UIFont systemFontOfSize:17];
        _subTitleLabel.textColor = [UIColor colorWithHex:@"999999"];
    }
    return _subTitleLabel;;
}

- (JRUIButton *)subCommitButton {
    if (!_subCommitButton) {
        _subCommitButton = [JRUIButton buttonWithType:UIButtonTypeCustom];
        [_subCommitButton setTitle:@"提交" forState:UIControlStateNormal];
        _subCommitButton.buttonStatus = JRPrincipalButtonStatus;
   
        [_subCommitButton addTarget:self action:@selector(subCommitEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subCommitButton;
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]init];
    }
    return _mainScrollView;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.itemSize = CGSizeMake(imageW, imageH);
        flowLayOut.sectionInset = UIEdgeInsetsMake(5, 0, 0, 5);
        flowLayOut.minimumLineSpacing = 0;
    
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, CurrentDeviceWidth - 50, imageH) collectionViewLayout:flowLayOut];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _itemWH = (self.collectionView.bounds.size.width - kTitleLeft-kCollectionViewRight ) / kMaxColumn - kMargin;
    }
    return _collectionView;
}

- (NSMutableArray *)photosArray{
    if (!_photosArray) {
        _photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

- (NSMutableArray *)otherLabelArray {
    if (!_otherLabelArray) {
        _otherLabelArray = [NSMutableArray array];
    }
    return _otherLabelArray;
}

#pragma mark - collectionDelegate dataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (_otherLabelArray.count) {
        return CGSizeMake(CurrentDeviceWidth, kSectionSpace);
    }
    return CGSizeZero;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _otherLabelArray.count;
    }else {
        /**
         @desc 选择图片限制最大张数
         @author 阿斌
         @date 2021-07-15
         @param msg 选择图片限制最大张数
         */
        if (self.max !=0 && _photosArray.count >= self.max) {
            return _photosArray.count;
        }
        return _photosArray.count+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        JRFileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JRFileCollectionViewCell" forIndexPath:indexPath];
        cell.fileModel = [self.otherLabelArray objectAtIndex:indexPath.row];
        cell.faildTitleLabel.text = @"上传失败";
        cell.faildTitleLabel.alpha = 0;
        cell.deleteButton.tag = 100 + indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(deleteFiles:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }else {
        
        JRImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JRImageCollectionViewCell" forIndexPath:indexPath];
        if (self.max !=0 && _photosArray.count >= self.max) {
            cell.imagev.contentMode = UIViewContentModeScaleAspectFill;
            cell.deleteButton.hidden = NO;
            cell.maskView.hidden = NO;
            cell.playButton.hidden = YES;
            cell.fileModel = _photosArray[indexPath.row];
        }
        else if (indexPath.row == _photosArray.count) {
            cell.imagev.contentMode = UIViewContentModeScaleAspectFit;
            cell.fileModel = nil;
            cell.tag = 8899;
            cell.imagev.image = [JRUIHelper imageNamed:@"btn_add"];
            cell.deleteButton.hidden = YES;
            cell.maskView.hidden = YES;
            cell.playButton.hidden = YES;
        }else{
            cell.imagev.contentMode = UIViewContentModeScaleAspectFill;
            cell.deleteButton.hidden = NO;
            cell.maskView.hidden = NO;
            cell.playButton.hidden = YES;
            cell.fileModel = _photosArray[indexPath.row];
        }
        cell.deleteButton.tag = 100 + indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(deletePhotos:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(CurrentDeviceWidth-70, kFileH-2);//返回两个小的cell的尺寸
    }else {
        return  CGSizeMake(_itemWH, _itemWH);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        if (_otherLabelArray.count) {
            JRBlankFootCollectionReusableView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"foot" forIndexPath:indexPath];
           
            footerView.backgroundColor = [UIColor clearColor];

            return footerView;
        }
       
        return nil;
    }



    return nil;

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (indexPath.row == _photosArray.count) {
            // 添加照片
            if (self.addFileEventBlock) {
                self.addFileEventBlock();
            }
        }else{
            
            JRImageCollectionViewCell *cell = (JRImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            //预览选中照片
            if (self.previewPhotoBlock) {
                self.previewPhotoBlock(self.photosArray[indexPath.row],indexPath.row,cell);
            }
            
        }
    }else {
        //预览文件
        if (self.previewFileBlock) {
            self.previewFileBlock(self.otherLabelArray[indexPath.row],indexPath.row);
        }
    }
}


#pragma mark - methods event

- (void)subCommitEvent:(UIButton *)sender {
    if (self.subCommitFileBlock) {
        self.subCommitFileBlock();
    }
}
/// 删除文件
- (void)deleteFiles:(UIButton *)sender{
    [self.otherLabelArray removeObjectAtIndex:sender.tag - 100];
    [self->_collectionView reloadData];
//    [_collectionView performBatchUpdates:^{
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag-100 inSection:0];
//        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
//    } completion:^(BOOL finished) {
//        [self->_collectionView reloadData];
//    }];
    [self updateCollectionFrame];
}
/// 删除图片
- (void)deletePhotos:(UIButton *)sender{
    [self.photosArray removeObjectAtIndex:sender.tag - 100];
    [self->_collectionView reloadData];
//    [_collectionView performBatchUpdates:^{
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag-100 inSection:1];
//        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
//    } completion:^(BOOL finished) {
//        [self->_collectionView reloadData];
//    }];
    [self updateCollectionFrame];
}
/// 更新collectionView 坐标
- (void)updateCollectionFrame {
    [self.collectionView reloadData];
    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@([self getConllectionHeight]));
    }];
}
    
-(CGFloat)getConllectionHeight{
    float imageHeight = ((self.photosArray.count + kMaxColumn)/kMaxColumn) * (_itemWH + kMargin) ;
    float fileHeight =  self.otherLabelArray.count * kFileH + (self.otherLabelArray.count ? kSectionSpace : 0) + (self.otherLabelArray.count ? (self.otherLabelArray.count-1)*10 : 0);
    float bottomSpace = 20;
    float allHeight =  imageHeight  + fileHeight + bottomSpace;
    return allHeight;
}



@end
