//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/29
* 维护人:  马克
* Copyright © 2021 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRPhotoEditeViewController.h"

@interface JRPhotoEditeViewController ()<TZImagePickerControllerDelegate>

@end

@implementation JRPhotoEditeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    JRCameraTypeDefault = 0,//拍照+拍摄
//    JRCameraTypePhotograph = 1,//拍照
//    JRCameraTypeShot = 2,//拍摄
    
    self.title = @"类型";
    
    UIView *view1 = [self buildLayoutView:@"普通(涂鸦-裁剪-调节-文字-马赛克)" setTag:990];
    view1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [self.view addSubview:view1];
    
    UIView *view2 = [self buildLayoutView:@"特殊的(裁剪-调节-矫正)" setTag:991];
    view2.frame = CGRectMake(0, 50, SCREEN_WIDTH, 50);
    [self.view addSubview:view2];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (UIView *)buildLayoutView:(NSString *)title setTag:(NSInteger)buttonTag{
    
    // 背景图
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    // 按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tag = buttonTag;
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    if (title.length>15) {
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    }else {
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -175, 0, 0)];
    }
    [backView addSubview:button];
    // 分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(8, 49, SCREEN_WIDTH*0.95, 1)];
    lineView.backgroundColor = [UIColor colorWithHex:@"f5f5f5"];
    [backView addSubview:lineView];
    
    return backView;
}

- (void)buttonEvent:(UIButton *)sender {
    switch (sender.tag) {
        case 990:
        {
//            [self camreaWithType:1];
            [self photoWithType:0];

        }
            break;
        case 991:
        {
            //                拍照
            JRCameraCustomVC *cameraVC = [[JRCameraCustomVC alloc] init];
            cameraVC.modalPresentationStyle = UIModalPresentationFullScreen;
            cameraVC.cameraType = 1;
            cameraVC.editType = 1;
            [self presentViewController:cameraVC animated:YES completion:nil];

        }
            break;
            
        default:
            break;
    }
}



/// @param Type 0 相册（仅照片） 1 相册（仅视频） 2 相册（图片+视频）

//拍照or拍摄
- (void)camreaWithType:(JRCameraType)type{
    //                拍照
    JRCameraCustomVC *cameraVC = [[JRCameraCustomVC alloc] init];
    cameraVC.modalPresentationStyle = UIModalPresentationFullScreen;
    cameraVC.cameraType = type;
    cameraVC.editType = 0;
    [self presentViewController:cameraVC animated:YES completion:nil];
}

/// 相册
/// @param Type 0 相册（仅照片） 1 相册（仅视频） 2 相册（图片+视频）
- (void)photoWithType:(NSInteger)type{
    JRImagePickerController  *imagePicker = [[JRImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePicker.showSelectedIndex = YES;
    imagePicker.showPhotoCannotSelectLayer = YES;
    imagePicker.allowPickingMultipleVideo = YES;
    imagePicker.videoMaximumDuration = 10 *60;
    imagePicker.videoLimitMaxDuration = 10;
    imagePicker.allowTakePicture = NO;
    imagePicker.allowTakeVideo = NO;
    if (type == 0) {
        imagePicker.allowPickingImage = YES;
        imagePicker.allowPickingVideo = NO;
    }
    else if (type == 1){
        imagePicker.allowPickingImage = NO;
        imagePicker.allowPickingVideo = YES;
    }
    else if (type == 2){
        imagePicker.allowPickingImage = YES;
        imagePicker.allowPickingVideo = YES;
    }
    
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}



- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    JRImageEditor *editor = [[JRImageEditor alloc] initWithImage:[photos lastObject] delegate:self];
    editor.editType = 0;
    editor.modalPresentationStyle = UIModalPresentationFullScreen;
    [editor addTransitionAnimation:self.view];
    [self presentViewController:editor animated:NO completion:nil];
    
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
