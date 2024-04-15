//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/16
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRRGBTool : NSObject

// 通过遍历像素点实现马赛克效果,level越大,马赛克颗粒越大,若level为0则默认为图片1/20
+ (UIImage *)getMosaicImageWith:(UIImage *)image level:(NSInteger)level;

// 通过滤镜来实现马赛克效果(只能处理.png格式的图片)
+ (UIImage *)getFilterMosaicImageWith:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
