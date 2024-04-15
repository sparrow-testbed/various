//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/2/22
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "UIImage+Extensions.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (Extensions)
- (UIImage*)imageWithCornerRadius:(CGFloat)radius {
    
    CGRect rect = (CGRect){0.f,0.f,self.size};
    
    // void UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale);
    //size——同UIGraphicsBeginImageContext,参数size为新创建的位图上下文的大小
    //    opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
    //    scale—–缩放因子
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    
    //根据矩形画带圆角的曲线
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    
    [self drawInRect:rect];
    
    //图片缩放，是非线程安全的
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}


/**
 *  返回一张可以随意拉伸，但四个角不变形的图片
 *
 *  @param name 图片名字
 */
+ (UIImage *)resizableImage:(NSString *)name {
    
    UIImage *resPic = [UIImage imageNamed:name];
    
    CGFloat w = resPic.size.width * 0.08;
    CGFloat h = resPic.size.height * 0.8;
    
    UIImage *desPic = [resPic resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
    
    return desPic;
}

+ (UIImage *)resizableLiveLeftImage:(NSString *)name {
    
    UIImage *resPic = [UIImage imageNamed:name];
    
    CGFloat w = resPic.size.width * .5;
    CGFloat h = resPic.size.height * .8;
    
    UIImage *desPic = [resPic resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
    
    return desPic;
}
+ (UIImage *)resizableliveRightImage:(NSString *)name {
    
    UIImage *resPic = [UIImage imageNamed:name];
    
    CGFloat w = resPic.size.width * 0.1;
    CGFloat h = resPic.size.height * 0.8;
    
    UIImage *desPic = [resPic resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
    
    return desPic;
}


+ (UIImage *)resizableLeftImage:(NSString *)name{
    
    UIImage *resPic = [UIImage imageNamed:name];
    
    UIImage *desPic = [resPic resizableImageWithCapInsets:UIEdgeInsetsMake(27, 20, 12, 12) resizingMode:UIImageResizingModeStretch]; // top > 0.5h
    
    return desPic;
}

+ (UIImage *)resizableRightImage:(NSString *)name{
    
    UIImage *resPic = [UIImage imageNamed:name];
    
    UIImage *desPic = [resPic resizableImageWithCapInsets:UIEdgeInsetsMake(27, 12, 12, 20) resizingMode:UIImageResizingModeStretch]; // top > 0.5h
    
    return desPic;
}

+ (UIImage *)resizablePlaceHolderImage:(NSString *)name edgeInsets:(UIEdgeInsets)edgeInsets {
    
    UIImage *resPic = [UIImage imageNamed:name];
    //UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5)
    UIImage *desPic = [resPic resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch]; // top > 0.5h
    
    return desPic;
}

- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:radians];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, degrees);
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 图片裁剪，适用于圆形头像之类
 
 @param image 要切圆的图片
 @param borderWidth 边框的宽度
 @param color 边框的颜色
 @return 切圆的图片
 */
+ (UIImage *)imageWithClipImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color {
    
    // 图片的宽度和高度
    CGFloat imageWH = image.size.width;
    
    // 设置圆环的宽度
    CGFloat border = borderWidth;
    
    // 圆形的宽度和高度
    CGFloat ovalWH = imageWH + 2 * border;
    
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalWH, ovalWH), NO, 0);
    
    // 2.画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ovalWH, ovalWH)];
    
    [color set];
    
    [path fill];
    
    // 3.设置裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(border, border, imageWH, imageWH)];
    [clipPath addClip];
    
    // 4.绘制图片
    [image drawAtPoint:CGPointMake(border, border)];
    
    // 5.获取图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return clipImage;
}

/**
 根据文字生成水印图片
 
 @param imageName 图片
 @param str 水印文字
 @param point 绘制水印文字的起始点
 @param dict 水印文字的属性字典
 @return 返回图片
 */
+ (UIImage *)imageWithWaterMarkImage:(NSString *)imageName text:(NSString *)str textPoint:(CGPoint)point textAttributes:(NSDictionary *)dict {
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    //把图片画上去
    [image drawAtPoint:CGPointZero];
    
    //绘制文字到图片
    [str drawAtPoint:point withAttributes:dict];
    
    // 从上下文获取图片
    UIImage *imageWater = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return imageWater;
}

/**
 根据图片生成水印图片
 
 @param image 图片
 @param waterImage 水印图片
 @param rect 水印图片的位置
 @return 返回图片
 */
+ (UIImage *)imageWithWaterMarkImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect {
    
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.绘制背景图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //绘制水印图片到当前上下文
    [waterImage drawInRect:rect];
    //3.从上下文中获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

/**
 截屏或者截取某个view视图
 
 @param captureView 要截取的view视图
 @return 返回截图
 */
+ (UIImage *)imageWithCaptureView:(UIView *)captureView {
    
    //开启位图上下文
    UIGraphicsBeginImageContextWithOptions(captureView.bounds.size, NO, 0);
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //把控件上的图层渲染到上下文
    [captureView.layer renderInContext:ctx];
    
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return screenImage;
}

/**
 根据颜色生成图片
 
 @param color 颜色
 @param size 图片的尺寸
 @return 返回生成的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    //开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 图片的等比例缩放
 
 @param image 图片
 @param defineWidth 要缩放到的宽度
 @return 返回与原图片等宽高比的图片
 */
+ (UIImage *)imageWithOriginImage:(UIImage *)image scaleToWidth:(CGFloat)defineWidth {
    
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/**
 根据图片名返回一张能够自由拉伸的图片
 
 @param name 图片名
 @param width 自由拉伸的宽度
 @param height 自由拉伸的高度
 @return 返回图片
 */
+ (UIImage *)imageWithResizedImage:(NSString *)name capWidth:(CGFloat)width capHeight:(CGFloat)height {
    
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:width topCapHeight:height];
}

- (UIImage *)normalizedImage {
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

+ (CGSize)getImageSizeWithURL:(id)URL {
    
    NSURL *url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        //以下是对手机32位、64位的处理（由网友评论区拿到的：小怪兽饲养猿）
        if (imageProperties != NULL) {
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
#if defined(__LP64__) && __LP64__
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
#else
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
            }
#endif
            CFRelease(imageProperties);
        }
        
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

/**
 *  画圆图片裁剪
 *
 *  @return 裁剪完成的图片
 */
- (instancetype)circleImage{
    // 开启图形上下文
    UIGraphicsBeginImageContext(self.size);
    // 获得图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    // 添加路径到上下文
    CGContextAddEllipseInRect(context, rect);
    // 裁剪（根据添加到上下文中的路径进行裁剪）
    // 以后超出裁剪后形状的内容都看不见
    CGContextClip(context);
    // 绘制图片到上下文中
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)circleImageNamed:(NSString *)name{
    return [[self imageNamed:name] circleImage];
}

//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName {
    
    NSData *imageData = UIImagePNGRepresentation(tempImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

/// 图片进行灰色处理
//+ (UIImage*)getGrayImage:(UIImage*)sourceImage {
//    int width = sourceImage.size.width;
//    int height = sourceImage.size.height;
//
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();//灰色
//    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,(CGBitmapInfo)kCGImageAlphaNone);
//    CGColorSpaceRelease(colorSpace);
//
//    if (context == NULL) {
//        return nil;
//    }
//
//    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
//    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
//    //CGContextRelease(context);
//    CGContextRelease(context);
//
//    return grayImage;
//}

+ (UIImage *)createCircleImageWithColor:(UIColor *)color diameter:(int)diameter
{
    // 创建一个圆形ImageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, diameter, diameter)];
    imageView.layer.cornerRadius = CGRectGetHeight(imageView.frame)/2;
    [imageView setBackgroundColor:color];
    
    // 将ImageView转换为UIImage
    UIGraphicsBeginImageContext(imageView.bounds.size);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageBlendedWithImage:(UIImage *)overlayImage blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {
    
    UIGraphicsBeginImageContext(self.size);
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:rect];
    
    [overlayImage drawAtPoint:CGPointMake(0, 0) blendMode:blendMode alpha:alpha];
    
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return blendedImage;
}

///
- (UIImage *)hyb_imageWithCornerRadius:(CGFloat)radius {
    
    CGRect rect = (CGRect){0.f, 0.f, self.size};
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)roundedCornerImageWithCornerRadius:(CGFloat)radius
{
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    if (radius < 0) {
        radius = 0;
    }else if(radius > MIN(w, h)){
        radius = MIN(w, h)/2.0;
    }
    UIImage *image = nil;
    CGRect imageFrame = CGRectMake(0, 0, w, h);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:radius] addClip];
    [self drawInRect:imageFrame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


//图片剪切
- (UIImage*)imageByRoundCornerRadius:(CGFloat)radius
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.;
    float y1 = 0.;
    float x2 = x1+self.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1+self.size.height;
    float x4 = x1;
    float y4 = y3;
    radius = radius*2;
    
    CGContextMoveToPoint(gc, x1, y1+radius);
    CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
    CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
    CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
    CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    
    
    CGContextClosePath(gc);
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0, self.size.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}


- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)imageRotateIndegree:(float)degree {
    //image -> context
    size_t width = (size_t)(self.size.width*self.scale);
    size_t height = (size_t)(self.size.height*self.scale);
    
    //表明每行图片数字字节
    size_t bytesPerRow = width*4;
    CGImageAlphaInfo alphaInfo = kCGImageAlphaPremultipliedFirst;//alpha
    //配置上下文参数
    CGContextRef bmContText = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault|alphaInfo);
    if (!bmContText) {
        return nil;
    }
    CGContextDrawImage(bmContText, CGRectMake(0, 0, width, height), self.CGImage);
    
    //2.旋转
    UInt8 *data = (UInt8*)CGBitmapContextGetData(bmContText);
    vImage_Buffer src = {data,height,width,bytesPerRow};
    vImage_Buffer dest = {data,height,width,bytesPerRow};
    Pixel_8888 bgColor = {0,0,0,0};
    vImageRotate_ARGB8888(&src, &dest, NULL, degree, bgColor, kvImageBackgroundColorFill);
    //3.context -> UIImage
    CGImageRef rotateImageref = CGBitmapContextCreateImage(bmContText);
    UIImage *rotateImage = [UIImage imageWithCGImage:rotateImageref scale:self.scale orientation:self.imageOrientation];
    return rotateImage;
}

- (UIImage *)imageCutSize:(CGRect)rect {
    CGImageRef subImageref = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallRect = CGRectMake(0, 0, CGImageGetWidth(subImageref), CGImageGetHeight(subImageref));
    UIGraphicsBeginImageContext(smallRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallRect, subImageref);
    UIImage *image = [UIImage imageWithCGImage:subImageref];
    UIGraphicsEndImageContext();
    return image;
}

// iOS上直接缩小UIImageView的大小会产生锯齿,可以先将其缩放后再使用
- (UIImage *)scaleToSize:(CGSize)size {
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize,image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (BOOL)imageSamllerThan512KWithImage:(UIImage *)image {
    
    if (!image) {
        return YES;
    }
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    
    NSInteger maxImageSize = 512*1024;
    if (data.length < maxImageSize) {
        return YES;
    }
    return NO;
}

- (UIImage *)getSmallImage:(CGSize)cutSize andImageData:(NSData *)imageData andURL:(NSURL *)url{
    
    CGSize size = CGSizeMake(cutSize.width, self.size.height / self.size.width * cutSize.width);
    CGFloat maxPixelSize = MAX(size.width*[UIScreen mainScreen].scale, size.height*[UIScreen mainScreen].scale);
    
    CGImageSourceRef sourceRef ;
    if (imageData) {
        sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, nil);
    }else if (url){
        sourceRef = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
        
    }else if (self){
        return [self scaleImage:self];
        //        NSData * data = UIImageJPEGRepresentation(self,0.5);
        //        sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
    }else {
        return nil;
    }
    
    NSDictionary *options = @{(__bridge id)kCGImageSourceCreateThumbnailFromImageAlways:(__bridge id)kCFBooleanTrue,
                              (__bridge id)kCGImageSourceThumbnailMaxPixelSize:[NSNumber numberWithFloat:maxPixelSize]
    };
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(sourceRef, 0, (__bridge CFDictionaryRef)options);
    UIImage *scaledImage = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CFRelease(sourceRef);
    return scaledImage;
}

- (UIImage *)scaleImage:(UIImage *)image{
    //确定压缩后的size
    CGFloat scaleWidth = image.size.width;
    CGFloat scaleHeight = image.size.height;
    CGSize scaleSize = CGSizeMake(scaleWidth, scaleHeight);
    //开启图形上下文
    UIGraphicsBeginImageContext(scaleSize);
    //绘制图片
    [image drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    //从图形上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSData *)compressImage:(UIImage *)image {
    
    if (!image) {
        return nil;
    }
    
    NSInteger maxImageSize = 512*1024;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0f); // JPEG为使图片大小增加两倍多
    
    if (data.length < maxImageSize) {
        return data;
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxImageSize && compression > maxCompression) {
        
        compression -= 0.1f;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return imageData;
    
    //替换while方法，优化压缩次数。20180702 y2785
    //    NSLog(@"----------startcompressimage:%ld",data.length/1024);
    //    CGFloat compression = 1;
    //    CGFloat max = 1;
    //    CGFloat min = 0;
    //    for (int i = 0; i < 6; ++i) {
    //        NSLog(@"----------:%d",i);
    //        compression = (max + min) / 2;
    //        data = UIImageJPEGRepresentation(image, compression);
    //        if (data.length < maxImageSize* 0.9) {
    //            min = compression;
    //        } else if (data.length > maxImageSize) {
    //            max = compression;
    //        } else {
    //            break;
    //        }
    //    }
    //    NSLog(@"----------endcompressimage:%ld",data.length/1024);
}

+ (NSData *)compress20MImage:(UIImage *)image{
    
    if (!image) {
        return nil;
    }
    
    NSInteger maxImageSize = 1024*1024 * 18;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0f); // JPEG为使图片大小增加两倍多
    
    if (data.length < maxImageSize) {
        return data;
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxImageSize && compression > maxCompression) {
        
        compression -= 0.1f;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    
    return imageData;
}

- (NSData *)compressQuality {
    NSInteger maxImageSize = 1024*1024 * 18;
    //    return [self compressQualityWithMaxLength:maxImageSize];
    return [self compressWithMaxLength:maxImageSize];
    
}

//
//- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength {
//   CGFloat compression = 1;
//    NSData *data = UIImageJPEGRepresentation(self, compression);
//    if (data.length < maxLength) return data;
//    CGFloat max = 1;
//    CGFloat min = 0;
//    for (int i = 0; i < 6; ++i) {
//        compression = (max + min) / 2;
//        data = UIImageJPEGRepresentation(self, compression);
//        if (data.length < maxLength * 0.9) {
//            min = compression;
//        } else if (data.length > maxLength) {
//            max = compression;
//        } else {
//            break;
//        }
//    }
//    return data;
//}
-(NSData *)imageTodata{
    UIGraphicsBeginImageContext(self.size);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    NSData *data = UIImageJPEGRepresentation(newImage, 1);
    return data;
}

-(NSData *)compressWithMaxLength:(NSUInteger)maxLength{
    @autoreleasepool {
        // Compress by quality
        CGFloat compression = 1;
        NSData *data =  UIImageJPEGRepresentation(self, compression);
        //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
        if (data.length < maxLength) return data;
        
        CGFloat max = 1;
        CGFloat min = 0;
        for (int i = 0; i < 6; ++i) {
            compression = (max + min) / 2;
            data =UIImageJPEGRepresentation(self, compression);
            //NSLog(@"Compression = %.1f", compression);
            //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
            if (data.length < maxLength * 0.9) {
                min = compression;
            } else if (data.length > maxLength) {
                max = compression;
            } else {
                break;
            }
        }
        NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength) return data;
        UIImage *resultImage = [UIImage imageWithData:data];
        // Compress by size
        NSUInteger lastDataLength = 0;
        while (data.length > maxLength && data.length != lastDataLength) {
            lastDataLength = data.length;
            CGFloat ratio = (CGFloat)maxLength / data.length;
            //NSLog(@"Ratio = %.1f", ratio);
            CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                     (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
            //            UIGraphicsBeginImageContext(size);
            //            [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            //            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            //            UIGraphicsEndImageContext();
            //
            //            data = UIImageJPEGRepresentation(resultImage, compression);
            
            CGFloat maxPixelSize = MAX(size.width*[UIScreen mainScreen].scale, size.height*[UIScreen mainScreen].scale);
            
            CGImageSourceRef sourceRef ;
            
            sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
            NSDictionary *options = @{(__bridge id)kCGImageSourceCreateThumbnailFromImageAlways:(__bridge id)kCFBooleanTrue,
                                      (__bridge id)kCGImageSourceThumbnailMaxPixelSize:[NSNumber numberWithFloat:maxPixelSize]
            };
            CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(sourceRef, 0, (__bridge CFDictionaryRef)options);
            UIImage *scaledImage = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:self.imageOrientation];
            CGImageRelease(imageRef);
            CFRelease(sourceRef);
            data = UIImageJPEGRepresentation(scaledImage, compression);
            //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
        }
        
        NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
        return data;
    }
}
@end
