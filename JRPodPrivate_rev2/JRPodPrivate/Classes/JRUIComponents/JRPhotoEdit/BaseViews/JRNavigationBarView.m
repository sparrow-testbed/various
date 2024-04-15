//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/16
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRNavigationBarView.h"
#import "JRUIKit.h"
@implementation JRNavigationBarView

+ (CGFloat)fixedHeight
{
    return 64;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    [self.doneButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    
    [self.cancleButton setImage:[JRUIHelper imageNamed:@"i_cancel_nor"] forState:UIControlStateNormal];
    [self.doneButton setImage:[JRUIHelper imageNamed:@"i_sure_nor"] forState:UIControlStateNormal];
}

- (IBAction)onCancelButtonTapped:(UIButton *)sender
{
    if (self.onCancelButtonClickBlock)
    {
        self.onCancelButtonClickBlock(sender);
    }
}

- (IBAction)onDoneButtonTapped:(UIButton *)sender
{
    if (self.onDoneButtonClickBlock)
    {
        self.onDoneButtonClickBlock(sender);
    }
}

@end
