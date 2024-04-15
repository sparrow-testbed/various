//
//  UIColor+XYAdd.m
//  ArtLibrary
//
//  Created by 徐勇 on 2017/4/7.
//  Copyright © 2017年 徐勇. All rights reserved.
//

#import "UIColor+XYAdd.h"

@implementation UIColor (XYAdd)
+ (UIColor *)randomColor {
    CGFloat hue = (arc4random() % 256 / 256.0);
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

+ (UIColor *)randomBackgroundColor {
    //7种随机色 ebd8cd e3b29d 9e7367 9fc9c2 d5f2e5 e7c5e0 566199
    NSArray *backgroundColors = @[@"ebd8cd",@"e3b29d",@"9e7367",@"9fc9c2",@"d5f2e5",@"e7c5e0",@"566199"];
    return [UIColor colorWithHex:[NSString stringWithFormat:@"#%@",backgroundColors[arc4random() % 7]]];
}
/// #000000
+ (UIColor *)titleTextColor {
    return [UIColor colorWithHex:@"#000000"];
}
/// #777777
+ (UIColor *)nameTextColor {
    return [UIColor colorWithHex:@"#686978"];
}
/// #999999
+ (UIColor *)detailTextColor {
    return [UIColor colorWithHex:@"#999999"];
}

/// #F0F0F0
+ (UIColor *)borderColor {
    return [UIColor colorWithHex:@"#F0F0F0"];
}

/// 背景色 #efeff4
+ (UIColor *)kNewBackgroundColor {
    return [UIColor colorWithHex:@"#F2F5F4"];
}

/// 导航栏默认绿色 #1aad19
+ (UIColor *)kDefaultGreenColor {
    return [UIColor colorWithHex:@"#1aad19"];
}

/// 时间#666666
+ (UIColor *)timeTextColor {
//    return [UIColor colorWithHex:@"#ADB1BC"];
    return [UIColor colorWithHex:@"#666666"];
}

+ (UIColor *)colorHex333333 {
    return [UIColor colorWithHex:@"#333333"];
}

#pragma mark — 扩展十六进制颜色转换

+ (UIColor *)colorWithHex:(NSString *)color {
    return [self colorWithHex:color alpha:1.0f];
}

+ (UIColor *)colorWithHex:(NSString *)hexColor alpha:(CGFloat)alpha {
    
    //!< 删除字符串中的空格
    NSString *colorStr = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //!< 字符串应该是6或8个字符
    if ([colorStr length] < 6){
        return [UIColor clearColor];
    }
    
    //!< 如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([colorStr hasPrefix:@"0X"]){
        colorStr = [colorStr substringFromIndex:2];
    }
    
    //!< 如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([colorStr hasPrefix:@"#"]){
        colorStr = [colorStr substringFromIndex:1];
    }
    
    //!< 最后判断字符串是否为六位字符
    if ([colorStr length] != 6){
        return [UIColor clearColor];
    }
    
    /**
     *  分离成R、G、B子字符串
     */
    NSString *redStr = [colorStr substringWithRange:NSMakeRange(0, 2)];    //!< red字符串
    NSString *greenStr = [colorStr substringWithRange:NSMakeRange(2, 2)];    //!< green字符串
    NSString *blueStr = [colorStr substringWithRange:NSMakeRange(4, 2)];    //!< blue字符串
    
    /**
     *  将十六进制的R、G、B转换为Int
     */
    unsigned int redInt, greenInt, blueInt;
    [[NSScanner scannerWithString:redStr] scanHexInt:&redInt];
    [[NSScanner scannerWithString:greenStr] scanHexInt:&greenInt];
    [[NSScanner scannerWithString:blueStr] scanHexInt:&blueInt];
    
    //!< 返回颜色值
    //return [UIColor colorWithRed:(redInt / 255.0f) green:(greenInt / 255.0f) blue:(blueInt / 255.0f) alpha:alpha];
    return [UIColor colorWith256RedValue:redInt greenValue:greenInt blueValue:blueInt alpha:alpha];
}

#pragma mark — 扩展RGB颜色转换

+ (UIColor *)colorWith256RedValue:(CGFloat)red greenValue:(CGFloat)green blueValue:(CGFloat)blue{
    return [UIColor colorWithRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha:1.0f];
}

+ (UIColor *)colorWith256RedValue:(CGFloat)red greenValue:(CGFloat)green blueValue:(CGFloat)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha:alpha];
}

@end
