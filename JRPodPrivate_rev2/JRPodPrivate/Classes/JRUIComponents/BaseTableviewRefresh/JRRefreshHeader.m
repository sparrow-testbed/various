/**
 * 所属系统: K信
 * 所属模块: 公共
 * 功能描述: 下拉刷新
 * 创建时间: 2016/7/21
 * 维护人:  张子飞
 * Copyright @ Jerrisoft 2019. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */

#import "JRRefreshHeader.h"
#import "JRUIKit.h"
#import "JRRefreshLoadingView.h"
@interface JRRefreshHeader()

@property (strong,nonatomic) JRRefreshLoadingView * loadingView;
@end
@implementation JRRefreshHeader

- (void)prepare
{
    [super prepare];

    self.mj_h = 40;

    _loadingView = [[JRRefreshLoadingView alloc]init];
    [self addSubview:_loadingView];
    _loadingView.hidden = YES;
    
}


#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    _loadingView.frame = CGRectMake((self.mj_w-33)/2, self.mj_h-17-10, 33, 17);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];

}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];

}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:

            [_loadingView stopAnimation];
            _loadingView.hidden = YES;
            break;
        case MJRefreshStatePulling:
            [self.loadingView stopAnimation];
            _loadingView.hidden = NO;
            break;
        case MJRefreshStateRefreshing:
            [self.loadingView startAnimation];
            _loadingView.hidden = NO;
            break;
        case MJRefreshStateNoMoreData:
            
            [self.loadingView stopAnimation];
            _loadingView.hidden = YES;
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];

}
@end
