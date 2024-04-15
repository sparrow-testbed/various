/**
 * 所属系统: K信
 * 所属模块: 公共
 * 功能描述: 上拉加载
 * 创建时间: 2016/7/21
 * 维护人:  张子飞
 * Copyright @ Jerrisoft 2019. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */

#import "JRRefreshFooter.h"
#import "JRUIKit.h"
#import "JRRefreshLoadingView.h"
@interface JRRefreshFooter()

@property (weak, nonatomic) UILabel *label;
@property (strong,nonatomic) JRRefreshLoadingView * loadingView;

@end

@implementation JRRefreshFooter
static NSString * const nomoreString = @"--没有更多了--";
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 40;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor jk_colorWithHexString:@"#bdbdbd"];
    label.font = [UIFont systemFontOfSize:13.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = nomoreString;
    [self addSubview:label];
    self.label = label;
    
    
    _loadingView = [[JRRefreshLoadingView alloc]init];
    [self addSubview:_loadingView];
    _loadingView.hidden = YES;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.label.frame = self.bounds;
    _loadingView.frame = CGRectMake((self.mj_w-33)/2, self.mj_h-17-10, 33, 17);
    
    self.label.center = CGPointMake(self.mj_w/2 , self.mj_h * 0.5);
    
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
            _label.hidden = YES;
            break;
            
        case MJRefreshStateRefreshing:
            [self.loadingView startAnimation];
            _loadingView.hidden = NO;
            break;
        case MJRefreshStateNoMoreData:
            _loadingView.hidden = YES;
            [self.loadingView stopAnimation];
            _label.hidden = NO;
            break;
        default:
            break;
    }
}


@end
