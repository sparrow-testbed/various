/**
 * 所属系统: 邮件
 * 所属模块: 邮件详情
 * 功能描述: 弹窗
 * 创建时间: 2019/2/28
 * 维护人:  张子飞
 * Copyright @ Jerrisoft 2019. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */

#import "JRActionSheetView.h"
#import "JRUIKit.h"

@interface JRActionSheetView ()
{
    CGSize _size;
}

@property(nonatomic,strong)UIView *menuView;
@property(nonatomic,strong)UIView *maskView;
@end

@implementation JRActionSheetView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray {
    if (self = [super initWithFrame:frame]) {
        _size = frame.size;
        [self makeBaseUIWithTitleArr:titleArray];
        
    }
    return self;
}

/**
 @desc 根据标题数组绘制UI
 @author 张子飞
 @date 2019/2/28
 @param titleArr 标题数组
 */
- (void)makeBaseUIWithTitleArr:(NSArray*)titleArr {

    self.menuView = [[UIView alloc]initWithFrame:CGRectMake(0, _size.height, _size.width, titleArr.count * 54 + 59 + BottomHeight)];
    self.menuView.backgroundColor = UIColor.whiteColor;
    
    self.maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.maskView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenSheet)];
    [self.maskView addGestureRecognizer:tap];
    [self addSubview:self.maskView];
    [self addSubview:self.menuView];
    
    CGFloat y = [self createBtnWithTitle:@"取消" origin_y: _menuView.frame.size.height - 54-BottomHeight tag:-1 action:@selector(hiddenSheet)] - 59;
    for (int i = 0; i < titleArr.count; i++) {
        y = [self createBtnWithTitle:titleArr[i] origin_y:y tag:i action:@selector(click:)];
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.menuView.frame;
        frame.origin.y -= frame.size.height;
        self.menuView.frame = frame;
        self.maskView.backgroundColor = [UIColor colorWithHex:@"#000000" alpha:0.5];
    }];
}

- (CGFloat)createBtnWithTitle:(NSString *)title origin_y:(CGFloat)y tag:(NSInteger)tag action:(SEL)method {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    if ([title isEqualToString:@"取消"]) {
        btn.frame = CGRectMake(0, y, _size.width, 54 + BottomHeight);
        btn.titleEdgeInsets = UIEdgeInsetsMake(-BottomHeight, 0, 0, 0);

        UIView *dividView = [[UIView alloc] initWithFrame:CGRectMake(0, y -7, SCREEN_WIDTH, 7)];
        dividView.backgroundColor = [UIColor colorWithHex:@"#F2F2F2"];
        [self.menuView addSubview:dividView];
    }else{
        UIView *dividView = [[UIView alloc] initWithFrame:CGRectMake(0, y - PixelOne, SCREEN_WIDTH, PixelOne)];
        dividView.backgroundColor = [UIColor colorWithHex:@"#F2F2F2"];
        [self.menuView addSubview:dividView];
        btn.frame = CGRectMake(0, y, _size.width, 54);
    }
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    btn.tag = tag;
    [btn setTitleColor:[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    if([title isEqualToString:@"视频通话"]){
        [btn setImage:[JRUIHelper imageNamed:@"i_video_chat_small"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 7)];
    }else if ([title isEqualToString:@"语音通话"]){
        [btn setImage:[JRUIHelper imageNamed:@"i_call_chat _smallActionSheet"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 7)];
    }
    [_menuView addSubview:btn];
    
    return y -= tag == -1 ? 0 : 54.4;
}

- (void)hiddenSheet {
    // 重置
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kActionSheetDismiss"];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.menuView.frame;
        frame.origin.y += frame.size.height;
        self.menuView.frame = frame;
        self.maskView.backgroundColor = [UIColor clearColor];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)click:(UIButton *)btn {
    if (self.ClickBlock) {
        self.ClickBlock(btn.tag);
    }
    [self hiddenSheet];//hidden
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
