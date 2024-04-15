//
//  MBProgressHUD+XYAdd.m
//  ArtLibrary
//
//  Created by 徐勇 on 16/7/19.
//  Copyright © 2016年 徐勇. All rights reserved.
//

#import "MBProgressHUD+XYAdd.h"
#import "UIImage+MBGif.h"
#import "JRUIKit.h"

static CGFloat alpha = 0.65; // 背景透明度
//static CGFloat kMargin = 25; // 图文 边距  -----> 固定大小
static CGFloat minWidth = 120; // 提示框最小尺寸  120*120

static CGFloat kTextMargin = 15; // 文字与边框间距
static CGFloat kTextFont = 16; // 文字大小

static NSTimeInterval defaultDelayTime = 15; // 默认菊花消失时间
static NSTimeInterval defaultShowTime = 1.5; // 默认提示框展示时间

static NSString *successImageName = @"i_right_toast"; // 成功提示图标
static NSString *errorImageName = @"i_wrong_toast"; // 失败提示图标

@implementation MBProgressHUD (XYAdd)

// 只显示菊花
+ (void)showHudLoading {
    [self showHudLoading:@"" toView:nil];
}

+ (void)showHudLoadingWithTitle:(NSString*)title{
    [self showHudLoading:title toView:nil];
}

+ (void)showHudLoading:(NSString *)message toView:(UIView *)view {
    // 主线程检测
    if ([NSThread isMainThread]) {
        if (view == nil) {
            view = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        [self showHudLoadingWithMessage:message toView:view];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (view == nil) {
                [self showHudLoadingWithMessage:message toView:[UIApplication sharedApplication].keyWindow];
            }
            [self showHudLoadingWithMessage:message toView:view];
        });
    }
}

+ (void)showHudLoadingWithMessage:(NSString *)message toView:(UIView *)view {
    // 设置菊花为白色
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    
    // iOS9
    //[[UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]] setColor:[UIColor whiteColor]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 使用UIActivityIndicatorView来显示进度，这是默认值
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.minShowTime = 0.3;
    hud.minSize = CGSizeMake(minWidth, minWidth);
    hud.margin = 0;
    
//    hud.label.text = message;
    [hud.label setText:message lineSpacing:6];
    [self configHUD:hud];
    
    [hud hideAnimated:YES afterDelay:defaultDelayTime];
}

+ (void)showHudLoading:(NSString *)message delay:(NSTimeInterval)time toView:(UIView *)view {
    defaultDelayTime = time;
    [self showHudLoading:message toView:view];
}

+ (void)dismissHud {
    [self dismissHudForView:nil];
}

+ (void)dismissHudForView:(UIView *)view {
    // 主线程检测
    if ([NSThread isMainThread]) {
        if (view == nil){
            view = [UIApplication sharedApplication].keyWindow;
        }
        [MBProgressHUD hideHUDForView:view animated:NO];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (view == nil){
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
            }
            [MBProgressHUD hideHUDForView:view animated:NO];
        });
    }
}

#pragma mark -

+ (void)showSuccess:(NSString *)message {
    [self showSuccess:message toView:nil completionBlock:^{
        
    }];
}

+ (void)showSuccess:(NSString *)message toView:(UIView *)view {
    // 主线程检测
    if ([NSThread isMainThread]) {
        [self show:message icon:successImageName view:view completionBlock:^{
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self show:message icon:successImageName view:view completionBlock:^{
            }];
        });
    }
}

+ (void)showSuccess:(NSString *)message completionBlock:(void(^)(void))completionBlock {
    [self showSuccess:message toView:nil completionBlock:^{
        completionBlock();
    }];
}

+ (void)showSuccess:(NSString *)message toView:(UIView *)view completionBlock:(void(^)(void))completionBlock {
    // 主线程检测
    if ([NSThread isMainThread]) {
        [self show:message icon:successImageName view:view completionBlock:^{
            completionBlock();
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self show:message icon:successImageName view:view completionBlock:^{
                completionBlock();
            }];
        });
    }
}

+ (void)showError:(NSString *)error {
    [self showError:error toView:nil];
}

+ (void)showError:(NSString *)error toView:(UIView *)view {
    // 主线程检测
    if ([NSThread isMainThread]) {
        [self show:error icon:errorImageName view:view completionBlock:^{
            
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self show:error icon:errorImageName view:view completionBlock:^{
                
            }];
        });
    }
}

+ (void)showError:(NSString *)error toView:(UIView *)view completionBlock:(void(^)(void))completionBlock {
    // 主线程检测
    if ([NSThread isMainThread]) {
        [self show:error icon:errorImageName view:view completionBlock:^{
            completionBlock();
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self show:error icon:errorImageName view:view completionBlock:^{
                completionBlock();
            }];
        });
    }
}

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view completionBlock:(void(^)(void))completionBlock {
    // UIImage *image = [[UIImage imageNamed:successImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//UIImageRenderingModeAlwaysTemplate
    // 是否已经存在
    [self dismissHudForView:view];
    
    if (view == nil){
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[JRUIHelper imageNamed:icon]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.square = YES;
    hud.minShowTime = 1.0;
    hud.minSize = CGSizeMake(minWidth, minWidth);
    hud.margin = 0;
    
//    hud.label.text = text;
    [hud.label setText:text lineSpacing:6];

    [self configHUD:hud];
    
    hud.completionBlock = completionBlock; // Called after the HUD is hiden
    [hud hideAnimated:YES afterDelay:defaultShowTime];
}

// only message
+ (void)showHUD:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHUD:message delay:defaultShowTime];
    });
}

+ (void)showHUD:(NSString *)message delay:(NSTimeInterval)time {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHUD:message toView:nil delay:time completionBlock:^{
               
           }];
    });
   
}

+ (void)showHUD:(NSString *)message completionBlock:(void(^)(void))completionBlock {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHUD:message toView:nil delay:defaultShowTime completionBlock:^{
            if (completionBlock) {
                completionBlock();
            }
        }];
    });
    
}

+ (void)showHUD:(NSString *)message toView:(UIView *)view delay:(NSTimeInterval)delay completionBlock:(void(^)(void))completionBlock {
    [self dismissHud];
    
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.numberOfLines = 0; // 多行展示 ？
    [hud.label setText:message lineSpacing:6];
    hud.margin = kTextMargin;
    
    [self configHUD:hud];
    
    hud.completionBlock = completionBlock;
    [hud hideAnimated:YES afterDelay:delay];
}

+ (void)configHUD:(MBProgressHUD *)hud {
    hud.label.font = [UIFont systemFontOfSize:kTextFont];
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:alpha];
    hud.removeFromSuperViewOnHide = YES; // 隐藏时候从父控件中移除
}

+ (void)showAnimationLoading:(NSString *)message toView:(UIView *)view{

    [MBProgressHUD showAnimationLoadingToView:view];

}

+ (void)showAnimationLoading:(NSString *)message toView:(UIView *)view delay:(NSTimeInterval)delay completionBlock:(void(^)(void))completionBlock{

    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.userInteractionEnabled = NO;
    hud.bezelView.color = [UIColor clearColor];
    hud.backgroundColor = [UIColor clearColor];
    [view addSubview:hud];
    
    UIView *effectView =  [[hud.subviews.lastObject subviews] firstObject];
    effectView.hidden = YES;
    
    hud.mode = MBProgressHUDModeCustomView;
    CGFloat height = 120;
    UIImageView *customView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 290, height, height)];
    customView.layer.cornerRadius = height/2;
    customView.layer.masksToBounds = YES;
    customView.center = CGPointMake(view.jk_centerX, 290 + height/2);
    customView.image =[JRUIHelper animatedGIFNamed:@"主-loading"];
    
    CGFloat bgHeight = 193;
    UIImageView * customBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgHeight, bgHeight)];
    customBgImageView.center = customView.center;
    customBgImageView.image = [JRUIHelper imageNamed:@"loadingViewBG"];
    [hud.backgroundView addSubview:customBgImageView];
    [hud.backgroundView addSubview:customView];
    hud.graceTime = 0.5;
    hud.completionBlock = completionBlock;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:delay];

}
+ (void)showAnimationLoading{
    UIView * view =[UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    UIView *effectView =  [[hud.subviews.lastObject subviews] firstObject];
    effectView.hidden = YES;
    hud.userInteractionEnabled = YES;
    hud.backgroundView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.bezelView.color = [UIColor clearColor];
    hud.backgroundColor = [UIColor clearColor];
    [view addSubview:hud];
   
    hud.mode = MBProgressHUDModeCustomView;

    CGFloat height = 120;
  
    UIImageView *customView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 290, height, height)];
    customView.layer.cornerRadius = height/2;
    customView.layer.masksToBounds = YES;
    customView.center =   CGPointMake(view.jk_centerX, 290 + height/2);
    customView.image =[JRUIHelper animatedGIFNamed:@"主-loading"];

    [hud.backgroundView addSubview:customView];
    hud.graceTime = 0.5;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:30];
}

+ (void)showAnimationLoadingToView:(UIView *)view{

    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    UIView *effectView =  [[hud.subviews.lastObject subviews] firstObject];
    effectView.hidden = YES;
    hud.userInteractionEnabled = YES;
    hud.backgroundView.color = [UIColor clearColor];
    hud.bezelView.color = [UIColor clearColor];
    hud.backgroundColor = [UIColor clearColor];
    [view addSubview:hud];
   
    hud.mode = MBProgressHUDModeCustomView;
    CGFloat height = 120;
    UIImageView *customView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 290, height, height)];
    customView.layer.cornerRadius = height/2;
    customView.layer.masksToBounds = YES;
    customView.center = CGPointMake(view.jk_centerX, 290 + height/2);
    customView.image =[JRUIHelper animatedGIFNamed:@"主-loading"];
    
    CGFloat bgHeight = 193;
    UIImageView * customBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgHeight, bgHeight)];
    customBgImageView.center = customView.center;
    customBgImageView.image = [JRUIHelper imageNamed:@"loadingViewBG"];
    [hud.backgroundView addSubview:customBgImageView];
    [hud.backgroundView addSubview:customView];
    hud.graceTime = 0.5;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:30];
}


@end
