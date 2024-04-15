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

#import "JRPhotoImageEditorViewController+CropView.h"
#import "TOCropViewController.h"
#import "JRUIKit.h"
#import "ViewFrameAccessor.h"


@interface JRPhotoImageEditorViewController (CropView)<TOCropViewControllerDelegate>

@end

@implementation JRPhotoImageEditorViewController (CropView)

- (void)beginCropView {
    [self buildCategoryClipImageWithBorder:NO complete:^(UIImage *clipedImage)
    {
//        JRStrongSelf(weakself)
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:clipedImage];
        cropController.delegate = self;
         //计算containerView 在 view中的位置
        CGRect viewFrame = [self.view convertRect:self.containerView.frame
                                           toView:self.navigationController.view];
        
        self.mosicaView.surfaceImageView.alpha = 0.0;
        
        [cropController
         presentAnimatedFromParentViewController:self
         fromImage:[self buildTransitionImage]
         fromView:self.containerView
         fromFrame:viewFrame
         angle:self.lastAngle
         toImageFrame:self.lastCropRect
         setup:nil
         completion:NULL];
    }];
}

#pragma mark - Clipe
- (void)buildCategoryClipImageWithBorder:(BOOL)border
                        complete:(void(^)(UIImage *clipedImage))complete
{
    
    [self.scrollView setZoomScale:1.0f];
    
    UIGraphicsBeginImageContextWithOptions(self.originSize,
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

//返回当前的imageView
- (UIImage *)buildTransitionImage
{
    [self.scrollView setZoomScale:1.0f];
    UIGraphicsBeginImageContextWithOptions(self.containerView.viewSize,
                                           NO,
                                           [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.originImage drawInRect:CGRectMake(0, 0, self.containerView.width, self.containerView.height)];
    [self.containerView.layer renderInContext:context];
    UIImage *transitionImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return transitionImage;
}

#pragma mark - Cropper Delegate
- (void)cropViewController:(TOCropViewController *)cropViewController
            didCropToImage:(UIImage *)image
                  withRect:(CGRect)cropRect
                     angle:(NSInteger)angle
{
    [self updateImageViewWithImage:image
                          withRect:cropRect
                             angle:angle
            fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)clipedImage
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
            weakself.mosicaView.surfaceImageView.image = clipedImage;
        }];
    }else
    {
        [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    

}

- (void)updateTransform:(CGFloat)angle withCropRect:(CGRect)cropRect
{
    [self resetImageViewFrameWithCropRect:cropRect];
    [self resetDrawViewUseAngle:angle cropRect:cropRect];
}

- (void)resetDrawViewUseAngle:(CGFloat)angle cropRect:(CGRect)cropRect
{
    CGFloat radius = (angle/180.0f)*M_PI;
    // 旋转
    CGAffineTransform rotation = CGAffineTransformMakeRotation(radius);
    self.drawingView.transform = rotation;
    self.imageView.transform = rotation;
    self.mosicaView.transform = rotation;
    

    
    if (angle == 0 || angle == -180)
    {
        CGFloat ratio = self.scrollView.width/cropRect.size.width;
        CGAffineTransform scale = CGAffineTransformMakeScale(ratio, ratio);
        self.imageView.transform = CGAffineTransformConcat(scale, self.imageView.transform);
        self.drawingView.transform = CGAffineTransformConcat(scale, self.drawingView.transform);
        self.mosicaView.transform = CGAffineTransformConcat(scale, self.mosicaView.transform);
        CGPoint viewOrigin = CGPointMake(-cropRect.origin.x * ratio, -cropRect.origin.y * ratio);
        self.drawingView.viewOrigin = viewOrigin;
        self.imageView.viewOrigin = viewOrigin;
        self.mosicaView.viewOrigin = viewOrigin;
    }
    else if (angle == -90 || angle == -270)
    {
        CGFloat ratio = self.scrollView.width/cropRect.size.width;
        CGAffineTransform scale = CGAffineTransformMakeScale(ratio, ratio);
        self.imageView.transform = CGAffineTransformConcat(scale, self.imageView.transform);
        self.drawingView.transform = CGAffineTransformConcat(scale, self.drawingView.transform);
        self.mosicaView.transform = CGAffineTransformConcat(scale, self.mosicaView.transform);

        CGPoint viewOrigin = CGPointMake(-cropRect.origin.x * ratio, -cropRect.origin.y * ratio);
        self.drawingView.viewOrigin = viewOrigin;
        self.imageView.viewOrigin = viewOrigin;
        self.mosicaView.viewOrigin = viewOrigin;

    }
}

#pragma mark - Reset
- (void)resetImageViewFrameWithCropRect:(CGRect)cropRect
{
    CGSize imageSize = cropRect.size;
    CGSize scrollViewSize = self.scrollView.frame.size;
    
    self.containerView.frame = CGRectMake(0, 0, scrollViewSize.width, imageSize.height*scrollViewSize.width/imageSize.width);
    
    // 设置scrollView的缩小比例;
    CGSize newImageSize = self.containerView.viewSize;
    CGFloat widthRatio = 1.0f; // 宽已经缩放了
    CGFloat heightRatio = scrollViewSize.height/newImageSize.height;
    if (heightRatio >= 1.0f) heightRatio = MAX(3.0f, heightRatio);
    
    self.scrollView.minimumZoomScale = MIN(widthRatio, heightRatio);
    self.scrollView.maximumZoomScale = MAX(widthRatio, heightRatio);
    self.scrollView.zoomScale = widthRatio;
    
    [self resetZoomScaleWithAnimated:NO];
}

- (void)resetZoomScaleWithAnimated:(BOOL)animated
{
    CGSize size = self.scrollView.bounds.size;
    CGSize contentSize = self.scrollView.contentSize;
    
    CGFloat offsetX = (size.width > contentSize.width) ?
    (size.width - contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (size.height > contentSize.height) ?
    (size.height - contentSize.height) * 0.5 : 0.0;
    
    self.containerView.center = CGPointMake(contentSize.width * 0.5 + offsetX, contentSize.height * 0.5 + offsetY);
    
}


@end
