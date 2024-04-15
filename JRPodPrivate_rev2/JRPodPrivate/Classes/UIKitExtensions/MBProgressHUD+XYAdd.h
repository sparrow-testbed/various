//
//  MBProgressHUD+XYAdd.h
//  ArtLibrary
//
//  Created by 徐勇 on 16/7/19.
//  Copyright © 2016年 徐勇. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (XYAdd)

/// show hud loading
+ (void)showHudLoadingWithTitle:(NSString*)title;
+ (void)showHudLoading;
+ (void)showHudLoading:(NSString *)message toView:(UIView *)view;
+ (void)showHudLoading:(NSString *)message delay:(NSTimeInterval)time toView:(UIView *)view;

/// hide hud
+ (void)dismissHud;
+ (void)dismissHudForView:(UIView *)view;

/// success image & text
+ (void)showSuccess:(NSString *)message;
+ (void)showSuccess:(NSString *)message toView:(UIView *)view;
+ (void)showSuccess:(NSString *)message completionBlock:(void(^)(void))completionBlock;
+ (void)showSuccess:(NSString *)message toView:(UIView *)view completionBlock:(void(^)(void))completionBlock;

/// error image & text
+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view completionBlock:(void(^)(void))completionBlock;

/// text
+ (void)showHUD:(NSString *)message;
+ (void)showHUD:(NSString *)message delay:(NSTimeInterval)time;
+ (void)showHUD:(NSString *)message completionBlock:(void(^)(void))compleBlock;
+ (void)showHUD:(NSString *)message toView:(UIView *)view delay:(NSTimeInterval)delay completionBlock:(void(^)(void))completionBlock;

//全局loading
+ (void)showAnimationLoading;
//局部loading
+ (void)showAnimationLoadingToView:(UIView *)view;
+ (void)showAnimationLoading:(NSString *)message toView:(UIView *)view;
+ (void)showAnimationLoading:(NSString *)message toView:(UIView *)view delay:(NSTimeInterval)delay completionBlock:(void(^)(void))completionBlock;

//icon
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view completionBlock:(void(^)(void))completionBlock;
@end
