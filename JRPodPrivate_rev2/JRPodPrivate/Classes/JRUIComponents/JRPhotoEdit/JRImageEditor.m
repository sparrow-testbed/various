//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/12
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRImageEditor.h"
#import "JRPhotoImageEditorViewController.h"
@interface JRImageEditor ()

@end

@implementation JRImageEditor


- (id)initWithImage:(UIImage*)image delegate:(id<JRImageEditorDelegate>)delegate
{    
    return [[JRPhotoImageEditorViewController alloc] initWithImage:image delegate:delegate];
}
//过渡动画效果
- (void)addTransitionAnimation:(UIView *)animatinView {
    //创建动画
    CATransition *animation = [CATransition animation];
    //设置运动轨迹的速度    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //设置动画类型为立方体动画
    animation.type = @"Fade";
    //设置动画时长
    animation.duration =0.5f;
    //设置运动的方向
    animation.subtype =kCATransitionFromRight;
    //控制器间跳转动画
    [animatinView.layer addAnimation:animation forKey:nil];
}


@end
