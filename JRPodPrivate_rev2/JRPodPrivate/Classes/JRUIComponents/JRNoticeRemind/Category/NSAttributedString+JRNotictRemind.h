//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/26
* 维护人:  李志䶮
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (JRNotictRemind)

/// 有文字的富文本字符串
/// @param string 字符串
/// @param textColor 文字颜色
/// @param font 字体
/// @param lineMargin 行间距
+ (NSAttributedString *)attributeString:(NSString *)string textColor:(UIColor *)textColor font:(UIFont *)font lineMargin:(int)lineMargin;

+ (NSAttributedString *)attributeString:(NSString *)string textColor:(UIColor *)textColor font:(UIFont *)font lineMargin:(int)lineMargin firstLineHeadIndent:(CGFloat)firstLineHeadIndent headIndent:(CGFloat)headIndent;

+ (CGFloat)getAttributeStringHeight:(NSString *)string font:(UIFont *)font lineMargin:(int)lineMargin width:(CGFloat)width firstLineHeadIndent:(CGFloat)firstLineHeadIndent headIndent:(CGFloat)headIndent;

@end

NS_ASSUME_NONNULL_END
