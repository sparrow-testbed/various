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

#import "JRTextColorPanel.h"
#import "JRUIKit.h"
@interface JRTextColorPanel ()



@end

@implementation JRTextColorPanel
+ (CGFloat)fixedHeight
{
    return 50;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    
    
    [self.textChangeBagGroundButton setImage:[JRUIHelper imageNamed:@"btn_txt_nor"] forState:UIControlStateNormal];
    [self.textChangeBagGroundButton setImage:[JRUIHelper imageNamed:@"btn_txt_pre"] forState:UIControlStateSelected];
    self.redButton.isUse = YES;
    self.currentColor = self.redButton.color;
        
}

- (void)setIsBagColorSelect:(BOOL)isBagColorSelect {
    _isBagColorSelect = isBagColorSelect;
    self.textChangeBagGroundButton.selected = _isBagColorSelect;
}

- (UIColor *)currentColor
{
    return _currentColor;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)panSelectColor:(UIPanGestureRecognizer *)recognizer
{
    
    NSLog(@"recon = %@", NSStringFromCGPoint([recognizer translationInView:self]));
}

- (IBAction)buttonAction:(UIButton *)sender
{
    JRColorfullButton *theBtns = (JRColorfullButton *)sender;
    
    for (JRColorfullButton *button in _colorButtons)
    {
        if (button == theBtns)
        {
            button.isUse = YES;
            self.currentButton = button; //每次选中都记下这个button
            // 背景色 和文字颜色都是同一个颜色 唯一区别是背景色的状态
            self.currentColor = theBtns.color;

            if (self.isBagColorSelect) {

                if (self.onTextBagColorChange)
                {
                    self.onTextBagColorChange(self.currentColor,self.isBagColorSelect);
                }
            }else {

                if (self.onTextColorChange)
                {
                    self.onTextColorChange(self.currentColor);
                }
            }
       
        }
        else
        {
            button.isUse = NO;
        }
    }
}
- (IBAction)setTextbagroundColor:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    self.isBagColorSelect = sender.selected;
    
    if (self.onTextBagColorChange)
    {
        self.onTextBagColorChange(self.currentColor,self.isBagColorSelect);
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"point: %@", NSStringFromCGPoint([touch locationInView:self]));
    NSLog(@"view=%@", touch.view);
    CGPoint touchPoint = [touch locationInView:self];
    for (JRColorfullButton *button in _colorButtons) {
        CGRect rect = [button convertRect:button.bounds toView:self];
        if (CGRectContainsPoint(rect, touchPoint) && button.isUse == NO) {
            [self buttonAction:button];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    //NSLog(@"move->point: %@", NSStringFromCGPoint([touch locationInView:self]));
    CGPoint touchPoint = [touch locationInView:self];
    
    for (JRColorfullButton *button in _colorButtons) {
        CGRect rect = [button convertRect:button.bounds toView:self];
        if (CGRectContainsPoint(rect, touchPoint) && button.isUse == NO) {
            [self buttonAction:button];
        }
    }
}

@end
