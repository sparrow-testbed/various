//
//  UIButton+JRExtension.h
//  JRPodPrivate_Example
//
//  Created by J0224 on 2020/11/24.
//  Copyright © 2020 wni. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    JRButtonImgViewStyleTop,
    JRButtonImgViewStyleLeft,
    JRButtonImgViewStyleBottom,
    JRButtonImgViewStyleRight,
} JRButtonImgViewStyle;


@interface UIButton (JRExtension)
+ (UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(CGFloat )size target:(id)target action:(SEL)action;

/**
 设置 按钮 图片所在的位置
 
 @param style   图片位置类型（上、左、下、右）
 @param size    图片的大小
 @param space 图片跟文字间的间距
 */
- (void)setImgViewStyle:(JRButtonImgViewStyle)style imageSize:(CGSize)size space:(CGFloat)space;
@end

NS_ASSUME_NONNULL_END
