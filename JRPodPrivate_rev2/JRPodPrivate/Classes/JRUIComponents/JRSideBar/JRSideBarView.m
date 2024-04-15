//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/23
* 维护人:  马克
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRSideBarView.h"

@implementation JRSideBarView

+ (void)showSideBarViewWithSuperView:(UIView *)superView containView:(UIView *)containView{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    JRSideBarView *sideView = [[JRSideBarView alloc]initWithFrame:CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height)];
    [superView addSubview:sideView];
    sideView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    tapGuesture.numberOfTapsRequired = 1;
    sideView.userInteractionEnabled = YES;
    [sideView addGestureRecognizer:tapGuesture];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(sideView.frame.size.width, 0, sideView.frame.size.width - 40, sideView.frame.size.height)];
    contentView.backgroundColor = [UIColor whiteColor];
    [sideView addSubview:contentView];
    
    containView.frame = contentView.bounds;
    [contentView addSubview:containView];
    
    [UIView animateWithDuration:0.3 animations:^{
        contentView.frame = CGRectMake(40, 0, sideView.frame.size.width - 40, sideView.frame.size.height);
    }];
}

+ (void)click:(UIGestureRecognizer *)recognizer{
    [self hiddenSideBarView:recognizer.view.superview];
}

+ (void)hiddenSideBarView:(UIView*)superView{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    for (UIView * view in superView.subviews) {
        if ([view isKindOfClass:[JRSideBarView class]]) {
            for (UIView * subview in view.subviews){
                if (subview) {
                    [UIView animateWithDuration:0.3 animations:^{
                        subview.frame = CGRectMake(view.frame.size.width, 0, view.frame.size.width, view.frame.size.height);
                    } completion:^(BOOL finished) {
                        [view removeFromSuperview];
                    }];
                    break;
                }
            }
            break;
        }
    }
    
}

@end
