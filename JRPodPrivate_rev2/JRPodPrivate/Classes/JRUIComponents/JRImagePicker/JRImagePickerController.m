//
//  JRImagePickerController.m
//  JRPodPrivate_Example
//
//  Created by 金煜祥 on 2020/9/21.
//  Copyright © 2020 wni. All rights reserved.
//

#import "JRImagePickerController.h"
#import "JRUIKit.h"
#define NAV_COLOR [UIColor jk_colorWithHexString:@"#174C30"]
#define DoneButtonTitle @"发送"
@interface JRImagePickerController ()

@end

@implementation JRImagePickerController
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<TZImagePickerControllerDelegate>)delegate{
    self = [super initWithMaxImagesCount:maxImagesCount delegate:delegate];
    [self configDefaultImage];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = NAV_COLOR;
 
  
    self.photoPickerPageUIConfigBlock = ^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        originalPhotoButton.enabled = YES;
    };
    
    self.photoPickerPageDidLayoutSubviewsBlock = ^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        bottomToolBar.frame = CGRectMake(0, self.view.jk_height - bottomToolBar.jk_height, self.view.jk_width, bottomToolBar.jk_height);
        //修改发送button样式
        [doneButton jk_setBackgroundColor:[UIColor jk_colorWithHexString:@"0EA856"] forState:UIControlStateNormal];
        doneButton.frame = CGRectMake(self.view.jk_width-16-84, 8, 84, 32);
        [doneButton jk_setBackgroundColor:[UIColor jk_colorWithHex:0x0EA856 andAlpha:0.4] forState:UIControlStateDisabled];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor jk_colorWithHex:0xffffff andAlpha:0.4] forState:UIControlStateDisabled];
        
        
        NSString * doneButtonTitle;
        if (numberLabel && [numberLabel.text intValue] > 0) {
            doneButtonTitle = [NSString stringWithFormat:@"%@(%@)",self.doneBottonString,numberLabel.text];
        }else{
            doneButtonTitle = self.doneBottonString;
        }
        [doneButton setTitle:doneButtonTitle forState:UIControlStateNormal];
        [doneButton setTitle:self.doneBottonString forState:UIControlStateDisabled];
        [doneButton jk_setRoundedCorners:UIRectCornerAllCorners radius:2];
        
        [previewButton setTitleColor:[UIColor jk_colorWithHexString:@"#43484D"] forState:UIControlStateNormal];
        previewButton.titleLabel.font = [UIFont systemFontOfSize:14];
        previewButton.frame = CGRectMake(13, 3, 36, 44);
        
        originalPhotoButton.frame = CGRectMake(originalPhotoButton.frame.origin.x + 10, originalPhotoButton.frame.origin.y, originalPhotoButton.frame.size.width, originalPhotoButton.frame.size.height);
        
        [originalPhotoButton setTitleColor:[UIColor jk_colorWithHexString:@"#43484D"] forState:UIControlStateNormal];
        [originalPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        originalPhotoLabel.textColor =[UIColor jk_colorWithHexString:@"#43484D"];
        originalPhotoLabel.font =[UIFont systemFontOfSize:14];
        
        divideLine.hidden = YES;
        numberLabel.hidden = YES;
        numberImageView.hidden = YES;
        
    };
    
    self.photoPickerPageDidRefreshStateBlock = ^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        //修改发送数量显示
        [doneButton setTitle:[NSString stringWithFormat:@"%@(%@)",self.doneBottonString,numberLabel.text] forState:UIControlStateNormal];
        numberLabel.hidden = YES;
        numberImageView.hidden = YES;
        originalPhotoButton.enabled = YES;
    };
    self.assetCellDidSetModelBlock = ^(TZAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView) {
        
    };
    self.assetCellDidLayoutSubviewsBlock = ^(TZAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView) {
        //修改photopicker assetCell样式
        selectImageView.layer.borderWidth = 1;
        selectImageView.layer.borderColor = UIColor.whiteColor.CGColor;
        selectImageView.layer.cornerRadius = 10;
        selectImageView.layer.masksToBounds = YES;
        selectImageView.bounds = CGRectMake(0, 0, 20, 20);
        CGFloat bottomViewHeight = 32;
        //添加渐变色的背景view
        bottomView.frame = CGRectMake(0, cell.height - bottomViewHeight, cell.width, bottomViewHeight);
        bottomView.backgroundColor = [UIColor clearColor];
        UIView * bottomMaskView = (UIView *)[bottomView viewWithTag:9999];
        if (!bottomMaskView) {
            bottomMaskView = [[UIView alloc]initWithFrame:bottomView.bounds];
            bottomMaskView.tag = 9999;
            CAGradientLayer *gradient = [CAGradientLayer layer];//创建渐变层
            gradient.frame = CGRectMake(0, 0, cell.width, bottomViewHeight);
            for (CALayer * layer in bottomView.layer.sublayers) {
                if ([layer isKindOfClass:[CAGradientLayer class]]) {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
            [bottomMaskView.layer addSublayer:gradient];
            
            [bottomView insertSubview:bottomMaskView atIndex:0];
            //渐变层的颜色梯度数组
            gradient.colors = @[(__bridge id)[UIColor jk_colorWithHex:0x000000 andAlpha:0.0] .CGColor,
                                (__bridge id)[UIColor jk_colorWithHex:0x000000 andAlpha:0.2] .CGColor,
                                (__bridge id)[UIColor jk_colorWithHex:0x000000 andAlpha:0.4] .CGColor];
            //渐变层的相对位置,起始点为0,终止点为1,中间点为 (point-startpoint)/(endpoint-startpoint)
            gradient.locations = @[@0,@.5,@1];
            //渐变方向
            gradient.startPoint = CGPointMake(0, 0);
            gradient.endPoint = CGPointMake(0, 1);
        }
        //修改视频flag样式和视频时间样式
        videoImgView.image = [JRUIHelper imageNamed:@"jr_video_photopicker_flag"];
        videoImgView.frame = CGRectMake(7, 5, 24, 24);
        videoImgView.layer.borderWidth = 0;
        timeLength.frame = CGRectMake(videoImgView.right + 4, 8, cell.width - videoImgView.right - 5, 18);
        timeLength.font = [UIFont systemFontOfSize:14];
        timeLength.textAlignment = NSTextAlignmentLeft;
    };
    self.photoPreviewPageUIConfigBlock = ^(UICollectionView *collectionView, UIView *naviBar, UIButton *backButton, UIButton *selectButton, UILabel *indexLabel, UIView *toolBar, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel) {
        
        //设置选择按钮的默认图片
        [selectButton setImage:[JRUIHelper imageNamed:@"jr_preview_photo_def"] forState:UIControlStateNormal];
        [selectButton setImage:[JRUIHelper imageNamed:@"jr_preview_photo_def_disable"] forState:UIControlStateDisabled];
    };
    __weak typeof(self) _self = self;
    self.photoPreviewPageDidLayoutSubviewsBlock = ^(UICollectionView *collectionView, UIView *naviBar, UIButton *backButton, UIButton *selectButton, UILabel *indexLabel, UIView *toolBar, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel) {
        __strong typeof(_self) self = _self;
        //修改预览页面的头
        naviBar.backgroundColor = NAV_COLOR;
        naviBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44+StateHeight);
        

        CGFloat toolBarHeight = 52+BottomHeight;
        CGFloat toolBarTop = SCREEN_HEIGHT - toolBarHeight;
        toolBar.frame = CGRectMake(0, toolBarTop, SCREEN_WIDTH, toolBarHeight);
        toolBar.backgroundColor = UIColor.whiteColor;
        
        //修改发送button样式
        [doneButton jk_setBackgroundColor:[UIColor jk_colorWithHexString:@"0EA856"] forState:UIControlStateNormal];
        doneButton.frame = CGRectMake(toolBar.width-16-84, 10, 84, 32);
        [doneButton jk_setBackgroundColor:[UIColor jk_colorWithHex:0x0EA856 andAlpha:0.4] forState:UIControlStateDisabled];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           [doneButton setTitleColor:[UIColor jk_colorWithHex:0xffffff andAlpha:0.4] forState:UIControlStateDisabled];
        NSString *sendStr = [NSString stringWithFormat:@"%@(%@)",self.doneBottonString,numberLabel.text];
        if ([numberLabel.text isEqualToString:@"0"]) {
            sendStr = self.doneBottonString;
        }
        [doneButton setTitle:sendStr forState:UIControlStateNormal];
        [doneButton setTitle:sendStr forState:UIControlStateDisabled];
        [doneButton jk_setRoundedCorners:UIRectCornerAllCorners radius:2];
        
        //修改原图按钮的样式
        [originalPhotoButton setTitleColor:[UIColor jk_colorWithHexString:@"#43484D"] forState:UIControlStateNormal];
        
        [originalPhotoButton setTitleColor:[UIColor jk_colorWithHexString:@"#43484D"] forState:UIControlStateSelected];
        originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:14];
        originalPhotoButton.frame =CGRectMake(originalPhotoButton.frame.origin.x,originalPhotoButton.frame.origin.y+ 4, originalPhotoButton.frame.size.width, selectButton.frame.size.height);
        originalPhotoLabel.textColor =[UIColor jk_colorWithHexString:@"#43484D"];
        originalPhotoLabel.font =[UIFont systemFontOfSize:14];
        
        backButton.frame = CGRectMake(11, StateHeight, 44, 44);
        [backButton setImage:[JRUIHelper imageNamed:@"i_back_nav_nor"] forState:UIControlStateNormal];
        
        selectButton.frame = CGRectMake(selectButton.frame.origin.x,selectButton.frame.origin.y+ 10, selectButton.frame.size.width, selectButton.frame.size.height);
        indexLabel.frame = CGRectMake(indexLabel.frame.origin.x,indexLabel.frame.origin.y+ 10, indexLabel.frame.size.width, indexLabel.frame.size.height);
        
    };

    self.photoPreviewPageDidRefreshStateBlock = ^(UICollectionView *collectionView, UIView *naviBar, UIButton *backButton, UIButton *selectButton, UILabel *indexLabel, UIView *toolBar, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel) {
        //修改发送数量统计
        __strong typeof(_self) self = _self;
        if ([numberLabel.text isEqualToString:@"0"]) {
            [doneButton setTitle:self.doneBottonString forState:UIControlStateNormal];
        }else{
            [doneButton setTitle:[NSString stringWithFormat:@"%@(%@)",self.doneBottonString,numberLabel.text] forState:UIControlStateNormal];
        }
      
        if (self.selectedModels.count == 0) {
            doneButton.enabled = NO;
        }else{
            doneButton.enabled = YES;
        }
        numberLabel.hidden = YES;
        numberImageView.hidden = YES;
    };
    
    // Do any additional setup after loading the view.
}

- (UIAlertController *)showAlertWithTitle:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:[NSBundle tz_localizedStringForKey:@"OK"] style:UIAlertActionStyleDefault handler:nil]];
    //    [self presentViewController:alertController animated:YES completion:nil];
    [MBProgressHUD showHUD:title];
    return alertController;
}

-(void)configDefaultImage{
    //设置基础图片
    self.iconThemeColor = [UIColor jk_colorWithHexString:@"0EA856"];
    self.photoSelImage = [JRUIHelper imageNamed:@"jr_photo_sel_photoPickerVc"];
    self.photoDefImage= [JRUIHelper imageNamed:@"jr_photo_def_photoPickerVc"];;
    self.photoOriginSelImage= [JRUIHelper imageNamed:@"jr_photo_original_sel"];
    self.photoOriginDefImage= [JRUIHelper imageNamed:@"jr_photo_original_def"];
    self.photoPreviewOriginDefImage= [JRUIHelper imageNamed:@"jr_preview_original_def"];
    self.photoNumberIconImage= [JRUIHelper imageNamed:@"jr_photo_number_icon"];
}

- (void)pushPhotoPickerVc {
    [self setValue:@NO forKey:@"_didPushPhotoPickerVc"];
    // 1.6.8 判断是否需要push到照片选择页，如果_pushPhotoPickerVc为NO,则不push
    if (![[self valueForKey:@"_didPushPhotoPickerVc"] boolValue] && [[self valueForKey:@"_pushPhotoPickerVc"] boolValue]) {
        JRPhotoPickerController *photoPickerVc = [[JRPhotoPickerController alloc] init];
        photoPickerVc.isFirstAppear = YES;
        photoPickerVc.columnNumber = [[self valueForKey:@"columnNumber"] integerValue];
        
        [[TZImageManager manager] getCameraRollAlbum:self.allowPickingVideo allowPickingImage:self.allowPickingImage needFetchAssets:NO completion:^(TZAlbumModel *model) {
            photoPickerVc.model = model;
            [self pushViewController:photoPickerVc animated:YES];
            [self setValue:@YES forKey:@"_didPushPhotoPickerVc"];
        }];
    }
}

- (NSString *)doneBottonString{
    if (_doneBottonString) {
        return _doneBottonString;
    }
    return DoneButtonTitle;
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
