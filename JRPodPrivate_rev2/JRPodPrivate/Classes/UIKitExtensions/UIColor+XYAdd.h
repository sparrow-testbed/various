//
//  UIColor+XYAdd.h
//  ArtLibrary
//
//  Created by 徐勇 on 2017/4/7.
//  Copyright © 2017年 徐勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XYAdd)
/// 随机色
+ (UIColor *)randomColor;

/// 背景色
+ (UIColor *)randomBackgroundColor;

/// 标题文字颜色
+ (UIColor *)titleTextColor;

/// 名称文字颜色
+ (UIColor *)nameTextColor;

/// 详情文字颜色 
+ (UIColor *)detailTextColor;

/// 边框颜色
+ (UIColor *)borderColor;

/// 背景色
+ (UIColor *)kNewBackgroundColor;

/// 导航栏默认绿色
+ (UIColor *)kDefaultGreenColor;

/// 时间
+ (UIColor *)timeTextColor;
/// 颜色333333
+ (UIColor *)colorHex333333;

#pragma mark — 扩展十六进制颜色转换
/// 十六进制颜色的字符串,支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHex:(NSString *)hexColor;

+ (UIColor *)colorWithHex:(NSString *)hexColor alpha:(CGFloat)alpha;

#pragma mark — 扩展RGB颜色转换

+ (UIColor *)colorWith256RedValue:(CGFloat)red greenValue:(CGFloat)green blueValue:(CGFloat)blue;

+ (UIColor *)colorWith256RedValue:(CGFloat)red greenValue:(CGFloat)green blueValue:(CGFloat)blue alpha:(CGFloat)alpha;

@end
