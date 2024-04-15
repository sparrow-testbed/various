//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/5/18
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRPhotoImageEditorViewController+CorrectView.h"
#import "JRPhotoImageEditorViewController+CropView.h"
#import "TOCropViewController.h"
#import "TOCropView+CorrectView.h"
#import "JRUIKit.h"
#import "ViewFrameAccessor.h"

@interface JRPhotoImageEditorViewController (CorrectView)<TOCropViewControllerDelegate>

@end

@implementation JRPhotoImageEditorViewController (CorrectView)
- (void)beginCorrectView {
    
    [self buildCorrectCategoryImageWithBorder:NO complete:^(UIImage *clipedImage)
    {
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:[self buildTransitionImage]];
        cropController.rotateButtonsHidden = YES;
        cropController.delegate = self;
        
        CGRect viewFrame = [self.view convertRect:self.containerView.frame
                                           toView:self.navigationController.view];

        [cropController
         presentAnimatedFromParentViewController:self
         fromImage:[self buildTransitionImage]
         fromView:self.containerView
         fromFrame:viewFrame
         angle:self.lastAngle
         toImageFrame:self.lastCropRect
         setup:nil
         completion:NULL];
        
        [cropController.cropView buildCorrectView];// 初始化矫正
        [cropController resetCropViewLayout];// 手动还原一下

    }];
}

- (void)buildCorrectCategoryImageWithBorder:(BOOL)border complete:(void(^)(UIImage *correctImage))complete
{

    
    [self.scrollView setZoomScale:1.0f];
    
    UIGraphicsBeginImageContextWithOptions(self.originCorrectSize,
                                           NO,
                                           [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.originImage drawInRect:CGRectMake(0, 0, self.originSize.width, self.originSize.height)];
    [self.mosicaView.layer renderInContext:ctx];
    [self.drawingView.layer renderInContext:ctx];

//    [self.containerView.layer renderInContext:ctx];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (complete)
    {
        complete(image);
    }

}

#pragma mark - 矫正代理回调
- (void)cropViewController:(TOCropViewController *)cropViewController didCropCorrectToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    [self updateImageViewWithCorrectImage:image
                          withRect:cropRect
                             angle:angle
            fromCropViewController:cropViewController];
}

- (void)updateImageViewWithCorrectImage:(UIImage *)clipedImage
                        withRect:(CGRect)cropRect
                           angle:(NSInteger)angle
          fromCropViewController:(TOCropViewController *)cropViewController
{
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    [self updateTransform:angle withCropRect:cropRect];

    self.lastCropRect = cropRect;
    self.lastAngle = angle;
    
    JRWeakSelf(self)
    if (cropViewController.croppingStyle != TOCropViewCroppingStyleCircular)
    {
        [cropViewController
         dismissAnimatedFromParentViewController:self
         withCroppedImage:clipedImage
         toView:self.containerView
         toFrame:self.containerView.frame
         setup:NULL
         completion:^{
            //更新矫正后的显示图片
            weakself.mosicaView.surfaceImage = clipedImage;
            weakself.mosicaView.surfaceImageView.image = clipedImage;
            weakself.imageView.image = clipedImage;
            weakself.originImage = clipedImage;
            weakself.mosicaView.frame = CGRectMake(0, 0, weakself.containerView.width, weakself.containerView.height);
            weakself.imageView.frame = CGRectMake(0, 0, weakself.containerView.width, weakself.containerView.height);
        }];
    }else
    {
        [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
}



@end
