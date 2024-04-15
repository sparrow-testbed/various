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

#ifndef JRUICommonDefines_h
#define JRUICommonDefines_h

#import <UIKit/UIKit.h>
#import "JRUIHelper.h"

#pragma mark - 变量-编译相关

/// 判断当前是否debug编译模式
#ifdef DEBUG
#define IS_DEBUG YES
#else
#define IS_DEBUG NO
#endif

#pragma mark - 变量-布局相关
/// 屏幕宽度，会根据横竖屏的变化而变化
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

/// 屏幕高度，会根据横竖屏的变化而变化
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define IOS11 [[[UIDevice currentDevice] systemVersion] floatValue]>11.00f
#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_Iphone_X  (Is_Iphone && (IOS11?[[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0 : NO ))
#define NaviHeight   (Is_Iphone_X ? 88 : 64)
#define TabbarHeight (Is_Iphone_X ? 83 : 49)
#define BottomHeight (Is_Iphone_X ? 34 : 0)
#define StateHeight  (Is_Iphone_X ? 44 : 20)

/// 获取一个像素
#define PixelOne [JRUIHelper pixelOne]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


#define XZYColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define NAME_TEXT_FONT      [UIFont systemFontOfSize:14]

#define CurrentDeviceWidth      [UIScreen mainScreen].bounds.size.width
#define CurrentDeviceHeight     [UIScreen mainScreen].bounds.size.height

#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define JRLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define BottomHeight (Is_Iphone_X ? 34 : 0)
#define     BaseGreenColor         [UIColor colorWithHex:@"#0EA856"]
#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_Iphone_X  (Is_Iphone && (IOS11?[[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0 : NO ))
#define IOS11 [[[UIDevice currentDevice] systemVersion] floatValue]>11.00f
#define kSeparatorLineColor [UIColor colorWithHex:@"#e0e1e4"]
#define MAIN_SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define MAIN_SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height

#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#define JRColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define     ClearColor       [UIColor clearColor]
#define TabbarHeight (Is_Iphone_X ? 83 : 49)
#define WhiteColor [UIColor whiteColor]
#define RedColor [UIColor redColor]

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

#pragma mark - # SIZE
#define     SIZE_SCREEN                 [UIScreen mainScreen].bounds.size
#define     WIDTH_SCREEN                [UIScreen mainScreen].bounds.size.width
#define     HEIGHT_SCREEN               [UIScreen mainScreen].bounds.size.height
#define     HEIGHT_STATUSBAR            20.0f
#define     HEIGHT_TABBAR               49.0f
#define     HEIGHT_NAVBAR               44.0f
#define     NAVBAR_ITEM_FIXED_SPACE     5.0f

#define     BORDER_WIDTH_1PX            ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)

#define     MAX_MESSAGE_WIDTH               WIDTH_SCREEN * 0.58
#define     MAX_MESSAGE_IMAGE_WIDTH         WIDTH_SCREEN * 0.45
#define     MIN_MESSAGE_IMAGE_WIDTH         WIDTH_SCREEN * 0.25
#define     MAX_MESSAGE_EXPRESSION_WIDTH    WIDTH_SCREEN * 0.35
#define     MIN_MESSAGE_EXPRESSION_WIDTH    WIDTH_SCREEN * 0.2
#define     HEIGHT_CHATBAR_TEXTVIEW         36.0f
#define     HEIGHT_MAX_CHATBAR_TEXTVIEW     111.5f
#define     HEIGHT_CHAT_KEYBOARD            215.0f

#define Lock_Guard(...) \
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
    __VA_ARGS__; \
    dispatch_semaphore_signal(_lock);


#define Lock_Guard_Lock(lock, ...) \
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER); \
    __VA_ARGS__; \
    dispatch_semaphore_signal(lock);

#pragma mark - # Methods
#define     JRURL(urlString)    [NSURL URLWithString:urlString]
#define     JRNoNilString(str)  (str.length > 0 ? str : @"")
#define     JRWeakSelf(type)    __weak typeof(type) weak##type = type;
#define     JRStrongSelf(type)  __strong typeof(type) strong##type = type;
#define     JRTimeStamp(date)   ([NSString stringWithFormat:@"%lf", [date timeIntervalSince1970]])
#define     JRGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#endif /* JRUICommonDefines_h */
