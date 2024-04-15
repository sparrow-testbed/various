//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/16
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

@interface NSString (JRCommon)
/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字符串的字体
 *  @param maxSize 字符串的最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont*)font maxSize:(CGSize)maxSize;

/**
 返回字符串所占用的尺寸

 @param font 字符串的字体
 @param lineSpactin 行间距
 @param maxSize 字符串的最大尺寸
 @return return CGSize
 */
- (CGSize)sizeFont:(UIFont *)font lineSpacing:(NSInteger)lineSpactin maxSize:(CGSize)maxSize;

+ (NSString *)FileSizeFromSizeValue:(unsigned long long)sizeValue;

+ (NSString *)getTimeWithDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
