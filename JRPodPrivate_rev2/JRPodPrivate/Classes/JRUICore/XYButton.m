//
//  XYButton.m
//  ArtLibrary
//
//  Created by JRuser on 16/5/23.
//  Copyright © 2016年 JRuser. All rights reserved.
//

#import "XYButton.h"

@implementation XYButton

// default returns YES if point is in bounds
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;

    // 若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    
    /*
     CGRectInset会进行平移和缩放两个操作
     CGRect CGRectInset(CGRect rect, CGFloat dx, CGFloat dy)
     第二个参数 dx 和第三个参数 dy 重置第一个参数 rect 作为结果返回。
     重置的方式为，首先将 rect 的坐标（origin）按照(dx,dy) 进行平移，
     然后将 rect 的大小（size） 宽度缩小2倍的 dx，高度缩小2倍的 dy。
     */
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);

    // 该方法没有扩大自定义按钮的frame值，只是单纯的将点击热区放大
    /* Return true if `point' is contained in `rect', false otherwise. */
    return CGRectContainsPoint(bounds, point);
}

//// 官方在视频中给出的示例源码
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)withEvent {
//    CGRect bounds = self.bounds;
//    CGFloat widthDelta = 44.0 - bounds.size.width;
//    CGFloat heightDelta = 44.0 - bounds.size.height;
//    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
//    return CGRectContainsPoint(bounds, point);
//}

@end
