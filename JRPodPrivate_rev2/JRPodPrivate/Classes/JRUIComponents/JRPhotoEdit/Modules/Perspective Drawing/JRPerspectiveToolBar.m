//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/30
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRPerspectiveToolBar.h"
#import "JRUIKit.h"
@implementation JRPerspectiveToolBar

+ (CGFloat)fixedHeight
{
    return 40;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 40)];
        buttonView.backgroundColor = [UIColor blackColor];
        [self addSubview:buttonView];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backButton setImage:[JRUIHelper imageNamed:@"i_return_big_nor"] forState:UIControlStateNormal];
        [buttonView addSubview:self.backButton];
        [self.backButton addTarget:self action:@selector(backLastType:) forControlEvents:UIControlEventTouchUpInside];

        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(buttonView.mas_right).offset(-10);
            make.centerY.mas_equalTo(buttonView.mas_centerY);
            make.width.height.equalTo(@40);
        }];
        
    }
    return self;
}

- (void)backLastType:(UIButton *)sender {
    if (self.backupStep) {
        self.backupStep();
    }
}

@end
