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

#import "JRMosicaToolBar.h"
#import "JRUIKit.h"

@interface JRMosicaToolBar ()

@property (weak, nonatomic) IBOutlet JRMosicaButton *brush1;
@property (weak, nonatomic) IBOutlet JRMosicaButton *brush2;
@property (weak, nonatomic) IBOutlet JRMosicaButton *brush3;
@property (weak, nonatomic) IBOutlet JRMosicaButton *brush4;
@property (weak, nonatomic) IBOutlet JRMosicaButton *brush5;

@end

@implementation JRMosicaToolBar

+ (CGFloat)fixedHeight
{
    return 55;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    
    [self.backButton setImage:[JRUIHelper imageNamed:@"i_return_big_nor"] forState:UIControlStateNormal];
    
    self.backButton.enabled = NO;
    
    self.brush1.dotViewSizeWidht = 7;
    self.brush2.dotViewSizeWidht = 10;
    self.brush3.dotViewSizeWidht = 13;
    self.brush4.dotViewSizeWidht = 16;
    self.brush5.dotViewSizeWidht = 18;
    
    self.brush3.isUse = YES;
    
}
- (IBAction)backButtonEvent:(UIButton *)sender {
    
    if (self.backButtonClickBlock)
    {
        self.backButtonClickBlock(sender);
    }
}
- (IBAction)setBrushSize:(JRMosicaButton *)sender {
    
    self.brushSizeWith = sender.dotViewSizeWidht;

    for (JRMosicaButton *btn in self.colorButtons) {
        if (btn == sender) {
            btn.isUse = YES;
        }else {
            btn.isUse = NO;
        }
    }
    if (self.lineWidthClickBlock) {
        self.lineWidthClickBlock(self.brushSizeWith);
    }
 
}

@end
