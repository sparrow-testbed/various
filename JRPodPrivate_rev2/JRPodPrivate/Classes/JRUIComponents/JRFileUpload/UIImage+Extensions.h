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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extensions)
/**
 图片设置圆角

 @param radius 3
 @return 图片
 */
- (UIImage*)imageWithCornerRadius:(CGFloat)radius;

+ (UIImage *)resizableImage:(NSString *)name;

+ (UIImage *)resizableLiveLeftImage:(NSString *)name;
+ (UIImage *)resizableliveRightImage:(NSString *)name;

+ (UIImage *)resizableLeftImage:(NSString *)name;

+ (UIImage *)resizableRightImage:(NSString *)name;

+ (UIImage *)resizablePlaceHolderImage:(NSString *)name edgeInsets:(UIEdgeInsets)edgeInsets;

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

/**
 图片裁剪，适用于圆形头像之类
 
 @param image 要切圆的图片
 @param borderWidth 边框的宽度
 @param color 边框的颜色
 @return 切圆的图片
 */
+ (UIImage *)imageWithClipImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color;

/**
 根据文字生成水印图片
 
 @param imageName 图片
 @param str 水印文字
 @param point 绘制水印文字的起始点
 @param dict 水印文字的属性字典
 @return 返回图片
 */
+ (UIImage *)imageWithWaterMarkImage:(NSString *)imageName text:(NSString *)str textPoint:(CGPoint)point textAttributes:(NSDictionary *)dict;

/**
 根据图片生成水印图片
 
 @param image 图片
 @param waterImage 水印图片
 @param rect 水印图片的位置
 @return 返回图片
 */
+ (UIImage *)imageWithWaterMarkImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect;

/**
 截屏或者截取某个view视图
 
 @param captureView 要截取的view视图
 @return 返回截图
 */
+ (UIImage *)imageWithCaptureView:(UIView *)captureView;

/**
 根据颜色生成图片
 
 @param color 颜色
 @param size 图片的尺寸
 @return 返回生成的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 图片的等比例缩放
 
 @param image 图片
 @param defineWidth 要缩放到的宽度
 @return 返回与原图片等宽高比的图片
 */
+ (UIImage *)imageWithOriginImage:(UIImage *)image scaleToWidth:(CGFloat)defineWidth;

/**
 根据图片名返回一张能够自由拉伸的图片
 
 @param name 图片名
 @param width 自由拉伸的宽度
 @param height 自由拉伸的高度
 @return 返回图片
 */
+ (UIImage *)imageWithResizedImage:(NSString *)name capWidth:(CGFloat)width capHeight:(CGFloat)height;

- (UIImage *)normalizedImage;

/**
 返回图片的尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)URL;

/// 画圆图片裁剪
- (instancetype)circleImage;

+ (instancetype)circleImageNamed:(NSString *)name;

/// 创建一个圆形UIImage
+ (UIImage *)createCircleImageWithColor:(UIColor *)color diameter:(int)diameter;

- (UIImage *)imageBlendedWithImage:(UIImage *)overlayImage blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;

/// 圆角
- (UIImage *)hyb_imageWithCornerRadius:(CGFloat)radius;

- (UIImage *)roundedCornerImageWithCornerRadius:(CGFloat)radius;

- (UIImage*)imageByRoundCornerRadius:(CGFloat)radius;


/// 角度修正
- (UIImage *)fixOrientation;

// 图片旋转，degree = 3.14/180
- (UIImage *)imageRotateIndegree:(float)degree;

//图片裁剪
- (UIImage *)imageCutSize:(CGRect)rect;

- (UIImage *)scaleToSize:(CGSize)size;
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

//大长图使用非drawRect方法防止内存溢出，裁剪
- (UIImage *)getSmallImage:(CGSize)cutSize andImageData:(NSData *)imageData andURL:(NSURL *)url;

/// 压缩图片算法二(压缩到512K以内)
+ (NSData *)compressImage:(UIImage *)image;

/// 压缩图片算法三(压缩到18M以内)
/// @param image image
+ (NSData *)compress20MImage:(UIImage *)image;

- (NSData *)compressQuality;

///图片是否小于512K
+ (BOOL)imageSamllerThan512KWithImage:(UIImage *)image ;
@end

NS_ASSUME_NONNULL_END
