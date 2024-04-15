//
//  UILabel+Utils.h
//  ManagementPlatform
//
//  Created by 张子飞 on 2018/4/20.
//  Copyright © 2018年 ITUser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Utils)


/**
 UILabel 设置行间距

 @param text 文本
 @param lineSpacing 间距
 */
- (void)setText:(NSString*)text andLineSpacing:(CGFloat)lineSpacing;

/**
 自定义行距之后，计算文本高度

 @param text 文本
 @param fontSize 文本字体大小
 @param width 宽度
 @param lineSpacing 行间距
 @return 实际高度
 */
+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;
@end
