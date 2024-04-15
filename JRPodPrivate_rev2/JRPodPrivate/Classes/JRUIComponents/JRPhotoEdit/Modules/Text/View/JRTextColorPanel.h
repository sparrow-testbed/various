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

#import <UIKit/UIKit.h>
#import "JRColorfullButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface JRTextColorPanel : UIView
@property (weak, nonatomic) IBOutlet UIButton *textChangeBagGroundButton;
@property (weak, nonatomic) IBOutlet JRColorfullButton *redButton;
@property (weak, nonatomic) IBOutlet JRColorfullButton *whiteButton;
@property (weak, nonatomic) IBOutlet JRColorfullButton *blackButton;
@property (weak, nonatomic) IBOutlet JRColorfullButton *yellowButton;
@property (weak, nonatomic) IBOutlet JRColorfullButton *greenButton;
@property (weak, nonatomic) IBOutlet JRColorfullButton *blueButton;
@property (weak, nonatomic) IBOutlet JRColorfullButton *purpleButton;

@property (strong, nonatomic) IBOutletCollection(JRColorfullButton) NSArray *colorButtons;

@property (strong, nonatomic)JRColorfullButton *currentButton;


@property (nonatomic, strong) UIColor *currentColor;
//@property (nonatomic, strong) UIColor *currentBagColor;
@property (nonatomic, copy) void (^onTextColorChange)(UIColor *color);
@property (nonatomic,copy)void (^onTextBagColorChange)(UIColor *color,BOOL isSelectColor);
@property (nonatomic,assign)BOOL isBagColorSelect;//是否背景选中


+ (CGFloat)fixedHeight;

- (void)buttonAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
