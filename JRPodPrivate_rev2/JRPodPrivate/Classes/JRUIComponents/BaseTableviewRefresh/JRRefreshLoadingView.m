//
//  JRRefreshLoadingView.m
//  JRPodPrivate
//
//  Created by 金煜祥 on 2021/4/9.
//

#import "JRRefreshLoadingView.h"
#import "JRUIKit.h"
static int vWidth = 6;
static int space = 3;

@implementation JRRefreshLoadingView
{
    NSMutableArray * subviewArray;
    dispatch_source_t _timer;
    NSInteger index;
    NSArray * colorArray;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        index = 0;
        subviewArray = [NSMutableArray new];
        colorArray = @[[UIColor jk_colorWithHexString:@"3F9FC3"],[UIColor jk_colorWithHexString:@"5BC27D"],[UIColor jk_colorWithHexString:@"F3C838"],[UIColor jk_colorWithHexString:@"E60013"]];
        for (NSInteger i =0; i<4; i++) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(i * (vWidth + space), 7, vWidth, vWidth)];
            view.backgroundColor = [colorArray objectAtIndex:i];
            view.layer.cornerRadius = vWidth/2;
            [subviewArray addObject:view];
            [self addSubview:view];
        }
       
//        [self startAnimation];
    }
    return self;
}

-(void)startAnimation{
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    //3.要调用的任务
    dispatch_source_set_event_handler(_timer, ^{
        if (self->index >= self->subviewArray.count) {
            self->index = 0;
        }
        UIView * view = [self->subviewArray objectAtIndex:self->index];
        view.backgroundColor = [self->colorArray objectAtIndex:self->index];
        if (view) {
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                view.transform = CGAffineTransformTranslate(view.transform, 0, -(self.jk_height-vWidth));
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    view.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    
                }];
            }];
            self->index++;
        }
        
    });
    
    //4.开始执行
    dispatch_resume(_timer);
}

-(void)stopAnimation{
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
        
    }
    index = 0;
}
#pragma mark --- 动画的代理方法
- (void)animationDidStart:(CAAnimation *)anim
{
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //  开启事务
    [CATransaction begin];

    // 关闭隐式动画属性
    [CATransaction setDisableActions:YES];

//    _layer.position = [[anim valueForKey:@"LayerPosition"] CGPointValue];

    [CATransaction commit];
    
}

-(UIColor *)getRandowColor{
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
