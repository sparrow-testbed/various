//
//  WBGImageEditorGestureManager.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/3/3.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "JRImageEditorGestureManager.h"
#import "JRTextToolView.h"

@interface JRImageEditorGestureManager ()
@property (nonatomic, strong) NSHashTable *gestureTable;
@end

@implementation JRImageEditorGestureManager

+ (instancetype)instance {
    static JRImageEditorGestureManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [JRImageEditorGestureManager new];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gestureTable = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:2];
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate
//同时识别两个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer.view isKindOfClass:[JRTextToolView class]] && [otherGestureRecognizer.view isKindOfClass:[JRTextToolView class]]) {
        NSArray *gestures = @[gestureRecognizer, otherGestureRecognizer];
        for (UIGestureRecognizer *ges in gestures) {
            if ([ges isKindOfClass:[UITapGestureRecognizer class]]) {
                return NO;
            }
        }
        return YES;
    } else {
        return NO;
    }
    
}

// 是否允许开始触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

// 是否允许接收手指的触摸点
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![self.gestureTable containsObject:gestureRecognizer]) {
        [self.gestureTable addObject:gestureRecognizer];
        if (self.gestureTable.count >= 2) {
            UIPanGestureRecognizer *textToolPan = nil;
            UIPanGestureRecognizer *drawToolPan = nil;
            
            for (UIPanGestureRecognizer *pan in self.gestureTable) {
                if ([pan.view isKindOfClass:[JRTextToolView class]]) {
                    textToolPan = pan;
                }
                if ([pan.view isKindOfClass:[UIImageView class]]) {
                    drawToolPan = pan;
                }
            }
            if (textToolPan && drawToolPan) {
                [drawToolPan requireGestureRecognizerToFail:textToolPan];
            }
        }
    }
    return YES;
}

@end
