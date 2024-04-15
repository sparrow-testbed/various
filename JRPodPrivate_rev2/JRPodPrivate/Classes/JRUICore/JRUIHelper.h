//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/15
* 维护人:  王伟
* Copyright © 2020 杰人软件. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRUIHelper : NSObject
/// 获取JRMUIKit.framework Images.xcassets 内的图片资源
/// @param name 图片名
+ (nullable UIImage *)imageNamed:(NSString *)name;


/// 获取gif图
/// @param name name description
+ (UIImage *)animatedGIFNamed:(NSString *)name;
/// 获取资源bundle
+ (NSBundle *)getResourceBundle;
/*!
 *  判断字符串是否为空，全部是空格也算空
 */
+ (BOOL)TextIsEmpty:(NSString *) str;
@end


@interface JRUIHelper (UIGraphic)

/// 获取一像素的大小
+ (CGFloat)pixelOne;

/// context是否合法
+ (void)inspectContextIfInvalidatedInDebugMode:(CGContextRef)context;
+ (BOOL)inspectContextIfInvalidatedInReleaseMode:(CGContextRef)context;
@end



NS_ASSUME_NONNULL_END
