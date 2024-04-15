//
//  UILabel+XYAdd.h
//  ArtLibrary
//
//  Created by 徐勇 on 16/8/1.
//  Copyright © 2016年 徐勇. All rights reserved.
//

/**
 *  以前总是很烦设计师非要说，让『把行距调大一点点』，因为在 iOS 这个对文字处理各种不友好的系统里，改行距并不像改字号那么简单，只调『一点点』也得多写好几行。
    不过自从我写了下面这些工具方法，调行距也就回归到它本来应该的样子：一行代码的事。
 */

#import <UIKit/UIKit.h>

@interface UILabel (XYAdd)

/**
 修改label内容距 `top` `left` `bottom` `right` 边距
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/// 设置行距
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

/// 计算行高
- (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;

+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;

/// 计算富文本行高
+ (CGFloat)heightWithText:(NSAttributedString *)text
                 fontSize:(CGFloat)fontSize
                    width:(CGFloat)width
              lineSpacing:(CGFloat)lineSpacing;

/// 返回高度
- (CGFloat)paragraphLabelHeightWithText:(NSString *)text
                               maxWidth:(CGFloat)maxWidth
                            lineSpacing:(CGFloat)lineSpacing;

#pragma mark -

/**
 给UILabel设置行间距和字间距
 
 @param label label
 @param str str
 @param font font
 @param lineSpace lineSpace
 */
+ (void)setLabelSpace:(UILabel *)label
               string:(NSString *)str
                 font:(UIFont *)font
            lineSpace:(CGFloat)lineSpace;


/**
 计算UILabel的高度(带有行间距的情况)
 
 @param str str
 @param font font
 @param width labelwidth
 @param lineSpace lineSpace
 @return labelHeight
 */
+ (CGFloat)getSpaceLabelHeightWithString:(NSString *)str
                                    font:(UIFont *)font
                                   width:(CGFloat)width
                               lineSpace:(CGFloat)lineSpace;

@end
