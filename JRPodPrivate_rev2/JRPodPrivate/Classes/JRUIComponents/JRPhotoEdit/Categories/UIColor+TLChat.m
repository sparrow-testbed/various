//
//  UIColor+TLChat.m
//  TLChat
//
//  Created by 李伯坤 on 16/1/27.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "UIColor+TLChat.h"
#import "JRUIKit.h"
@implementation UIColor (TLChat)

#pragma mark - # 字体
+ (UIColor *)colorTextBlack {
    return [UIColor blackColor];
}

+ (UIColor *)colorTextGray {
    return [UIColor grayColor];
}

+ (UIColor *)colorTextGray1 {
    return JRGBColor(160, 160, 160, 1.0);
}

#pragma mark - 灰色
+ (UIColor *)colorGrayBG {
    return JRGBColor(239.0, 239.0, 244.0, 1.0);
}

+ (UIColor *)colorGrayCharcoalBG {
    return JRGBColor(235.0, 235.0, 235.0, 1.0);
}

+ (UIColor *)colorGrayLine {
    return [UIColor colorWithWhite:0.5 alpha:0.3];
}

+ (UIColor *)colorGrayForChatBar {
    return JRGBColor(245.0, 245.0, 245.0, 1.0);
}

+ (UIColor *)colorGrayForMoment {
    return JRGBColor(243.0, 243.0, 245.0, 1.0);
}




#pragma mark - 绿色
+ (UIColor *)colorGreenDefault {
    return JRGBColor(2.0, 187.0, 0.0, 1.0f);
}


#pragma mark - 蓝色
+ (UIColor *)colorBlueMoment {
    return JRGBColor(74.0, 99.0, 141.0, 1.0);
}

#pragma mark - 黑色
+ (UIColor *)colorBlackForNavBar {
    return JRGBColor(20.0, 20.0, 20.0, 1.0);
}

+ (UIColor *)colorBlackBG {
    return JRGBColor(46.0, 49.0, 50.0, 1.0);
}

+ (UIColor *)colorBlackAlphaScannerBG {
    return [UIColor colorWithWhite:0 alpha:0.6];
}

+ (UIColor *)colorBlackForAddMenu {
    return JRGBColor(71, 70, 73, 1.0);
}

+ (UIColor *)colorBlackForAddMenuHL {
    return JRGBColor(65, 64, 67, 1.0);
}


@end
