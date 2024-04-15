//
//  UIBarButtonItem+ZF.h
//  JRDirector
//
//  Created by ITUser on 16/6/21.
//  Copyright © 2016年 ITUser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZF)

/**
 *  快速创建一个显示图片的item
 */
+ (UIBarButtonItem *)itemWithAllTitle:(NSString *)icon TitleColor:(UIColor *)color Target:(id)target Action:(SEL)action;
+ (UIBarButtonItem *)itemWithIcon:(NSString*)icon highIcon:(NSString*)highIcon target:(id)target action:(SEL)action;


+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithIcon2:(NSString *)icon target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithAllTitle:(NSString *)icon target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor offset:(CGFloat)offset target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithTitle2:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title Icon:(NSString *)icon target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title color:(UIColor*)color target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

///奖学金使用
+ (UIBarButtonItem *)itemCouponWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

// 写邮件使用
+ (UIBarButtonItem *)itemWithWriteMailTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithMailSaveIcon:(NSString *)icon target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithMailSendIcon:(NSString *)icon target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithMeetTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithDeleteMeetPersonTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithMailTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithMailTitle1:(NSString *)title target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemSpaceView;

+ (UIBarButtonItem *)itemWithMailButton:(UIButton *)button target:(id)target action:(SEL)action;

@end


