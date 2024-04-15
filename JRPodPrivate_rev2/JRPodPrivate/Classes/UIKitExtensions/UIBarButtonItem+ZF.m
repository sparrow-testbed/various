//
//  UIBarButtonItem+ZF.m
//  JRDirector
//
//  Created by ITUser on 16/6/21.
//  Copyright © 2016年 ITUser. All rights reserved.
//

#import "UIBarButtonItem+ZF.h"
#import "JRUIKit.h"

@implementation UIBarButtonItem (ZF)

+ (UIBarButtonItem *)itemWithAllTitle:(NSString *)icon TitleColor:(UIColor *)color Target:(id)target Action:(SEL)action {
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:icon forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.frame = CGRectMake(0, 0, 40, 22);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action {

    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero,button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon target:(id)target action:(SEL)action {
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    if ([icon isEqualToString:@"icon_write_return"]) {
        button.frame = CGRectMake(0, 0, 55, 44);
    } else {
        button.frame = CGRectMake(0, 0, 40, 40);
    }
    
    // 设置button的图片位置在左还是右 石拓 20180320
    if ([icon isEqualToString:@"icon_write_return"]
        || [icon isEqualToString:@"return_back_icon"]
        || [icon isEqualToString:@"icon_return"]) {
        button.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    } else {
        button.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    }
    
    
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithIcon2:(NSString *)icon target:(id)target action:(SEL)action{
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 43, 22);
    button.tag = 612;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithAllTitle:(NSString *)icon target:(id)target action:(SEL)action {
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitle:icon forState:UIControlStateNormal];
    [button setTitleColor:JRColor(18, 171, 30) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.frame = CGRectMake(0, 0, 60, 22);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title color:(UIColor*)color target:(id)target action:(SEL)action {
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 25);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:color forState:UIControlStateNormal];
     [button setTitleColor:[UIColor colorWithHex:@"ADB1BC"] forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 25);//40
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action {
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 25);//40
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];

//        [button setTitleColor:BaseGreenColor forState:UIControlStateNormal];

    } else {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor offset:(CGFloat)offset target:(id)target action:(SEL)action {
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.frame = CGRectMake(0, 0, 40+offset, 25);//40
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    
    if (titleColor) {
        
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    } else {
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}


+ (UIBarButtonItem *)itemCouponWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action {
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 70, 25);
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor redColor];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithTitle2:(NSString *)title target:(id)target action:(SEL)action{
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 25);//40
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title Icon:(NSString *)icon target:(id)target action:(SEL)action{
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 140, 25);
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

// 写邮件  保存 发送
+ (UIBarButtonItem *)itemWithMailSaveIcon:(NSString *)icon target:(id)target action:(SEL)action {
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:JRColor(15, 180, 33) forState:UIControlStateNormal];
    [button setTitle:icon forState:UIControlStateNormal];
    button.layer.borderColor = JRColor(15, 180, 33).CGColor;
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.layer.borderWidth = 0.5;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.frame = CGRectMake(0, 0, 43, 22);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithMailSendIcon:(NSString *)icon target:(id)target action:(SEL)action {
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitle:icon forState:UIControlStateNormal];
    [button setBackgroundColor:JRColor(15, 180, 33)];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.frame = CGRectMake(0, 0, 43, 22);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithWriteMailTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 25);//40
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:HexRGBAlpha(0x10b420, 1) forState:UIControlStateNormal];
    [button setTitleColor:HexRGBAlpha(0xbdbfc1, 1) forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithMeetTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 70, 25);//40
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithDeleteMeetPersonTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 25);//40
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithMailTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 80, 25);//40
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_write_return"] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithMailTitle1:(NSString *)title target:(id)target action:(SEL)action {
    
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 80, 25);
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"i_cancel_nav_nor_"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"i_cancel_nav_pre_"] forState:UIControlStateSelected];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];//10
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemSpaceView {
    
    UIView *spaceV = [[UIView alloc] init];
    spaceV.backgroundColor = ClearColor;
    spaceV.frame = CGRectMake(0, 0, 5, 22);
    return [[UIBarButtonItem alloc]initWithCustomView:spaceV];
}

+ (UIBarButtonItem *)itemWithMailButton:(UIButton *)button target:(id)target action:(SEL)action {
    
    button.frame = CGRectMake(-10, 0, 28, 40);
    [button setImage:[UIImage imageNamed:@"i_menu1_nav_nor_"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"i_menu2_nav_nor_"] forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

@end
