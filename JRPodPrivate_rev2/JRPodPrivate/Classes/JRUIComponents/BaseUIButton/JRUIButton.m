//
/**
* 所属系统: component
* 所属模块: UIButton
* 功能描述: BaseButton
* 创建时间: 2020/9/18
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRUIButton.h"
#import "JRUIKit.h"

@implementation JRUIButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:14/255.0 green:168/255.0 blue:86/255.0 alpha:1.0];
        self.layer.shadowColor =  [UIColor colorWithRed:24/255.0 green:42/255.0 blue:77/255.0 alpha:0.3].CGColor;
        [self setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.layer.shadowOffset = CGSizeMake(0,3);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 3;
        self.layer.cornerRadius = 5;
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecordButton:)];
        longTap.cancelsTouchesInView = NO;
        longTap.minimumPressDuration = 0.01;
        [self addGestureRecognizer:longTap];
    }
    return self;
}

- (void)longPressRecordButton:(UILongPressGestureRecognizer *)tapG {
    //语音开始
    if(tapG.state == UIGestureRecognizerStateBegan) {
        UIView *vi= [self viewWithTag:999];
        if (!vi) {
            UIView *vi = [[UIView alloc]initWithFrame:self.bounds];
            vi.layer.cornerRadius = self.layer.cornerRadius;
            vi.tag = 999;
            vi.backgroundColor = [UIColor colorWithHex:@"#000000" alpha:0.1];
            [self addSubview:vi];
        }
    } else if(tapG.state == UIGestureRecognizerStateEnded) {
        [self removeVi];
    } else if(tapG.state == UIGestureRecognizerStateChanged) {
    }
}


- (void)removeVi{
    UIView *vi= [self viewWithTag:999];
    if (vi) {
        [vi removeFromSuperview];
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    [self setBackgroundColor:bgColor];
}

- (void)setShadowColor:(UIColor *)shadowColor{
    _shadowColor = shadowColor;
    self.layer.shadowColor = shadowColor.CGColor ?: [UIColor colorWithRed:24/255.0 green:42/255.0 blue:77/255.0 alpha:0.3].CGColor;
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}


- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

//JRPrincipalButtonStatus,//主要按钮
//JRSecondaryButtonStatus,//次要按钮
//JRDangerButtonStatus,//危险按钮
//JRSegmentNormalButtonStatus,//选项卡通用状态
//JRSegmentSelectButtonStatus,//选项卡选择状态
- (void)setButtonStatus:(JRButtonStatus)buttonStatus{
    self.layer.shadowColor =  [UIColor clearColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0;
    self.layer.shadowRadius = 0;
    _buttonStatus = buttonStatus;
    switch (buttonStatus) {
        case JRPrincipalButtonStatus:
            self.userInteractionEnabled = true;
            self.bgColor = [UIColor colorWithHex:@"#0EA856"];
            self.layer.shadowColor =  [UIColor colorWithRed:24/255.0 green:42/255.0 blue:77/255.0 alpha:0.3].CGColor;
            self.titleColor = [UIColor colorWithHex:@"#FFFFFF"];
            self.layer.shadowOffset = CGSizeMake(0,3);
            self.layer.shadowOpacity = 1;
            self.layer.shadowRadius = 3;
            self.layer.cornerRadius = 5;
            self.titleLabel.font = [UIFont systemFontOfSize:18];
            break;
        case JRSecondaryButtonStatus:
            self.userInteractionEnabled = true;
            self.bgColor = [UIColor colorWithHex:@"#FFFFFF"];
            self.titleColor = [UIColor colorWithHex:@"#000000"];
            self.layer.cornerRadius = 5;
            self.layer.borderWidth = 0.6 * PixelOne;
            self.layer.borderColor = [UIColor colorWithHex:@"#ABC0BA"].CGColor;
            self.layer.masksToBounds = true;
            self.titleLabel.font = [UIFont systemFontOfSize:18];
            break;
        case JRDangerButtonStatus:
            self.userInteractionEnabled = true;
            self.bgColor = [UIColor colorWithHex:@"#FFFFFF"];
            self.titleColor = [UIColor colorWithHex:@"#F55C54"];
            self.layer.cornerRadius = 5;
            self.layer.borderWidth = 0.6 * PixelOne;
            self.layer.borderColor = [UIColor colorWithHex:@"#ABC0BA"].CGColor;
            self.layer.masksToBounds = true;
            self.titleLabel.font = [UIFont systemFontOfSize:18];
            break;
        case JRSegmentNormalButtonStatus:
            self.userInteractionEnabled = true;
            self.bgColor = [UIColor colorWithHex:@"#FFFFFF"];
            self.titleColor = [UIColor colorWithHex:@"#0EA856"];
            self.layer.cornerRadius = 3;
            self.layer.borderWidth = 0.3 * PixelOne;
            self.layer.borderColor = [UIColor colorWithHex:@"#1AA84A"].CGColor;
            self.titleLabel.font = [UIFont systemFontOfSize:15];
            break;
        case JRSegmentSelectButtonStatus:
            self.userInteractionEnabled = true;
            self.bgColor = [UIColor colorWithHex:@"#0EA856"];
            self.titleColor = [UIColor colorWithHex:@"#FFFFFF"];
            self.layer.cornerRadius = 3;
            self.titleLabel.font = [UIFont systemFontOfSize:15];
            break;
        case JRYearsNormalButtonStatus:
            self.userInteractionEnabled = true;
            self.bgColor = [UIColor colorWithHex:@"#F0F4F3"];
            self.titleColor = [UIColor colorWithHex:@"#565656"];
            self.layer.cornerRadius = 15;
            self.titleLabel.font = [UIFont systemFontOfSize:14];
            break;
        case JRYearsSelectButtonStatus:
            self.userInteractionEnabled = true;
            self.bgColor = [UIColor colorWithHex:@"#1AA84A" alpha:0.1];
            self.titleColor = [UIColor colorWithHex:@"#0EA856"];
            self.layer.cornerRadius = 15;
            self.titleLabel.font = [UIFont systemFontOfSize:14];
            self.layer.borderWidth = 0.5 * PixelOne;
            self.layer.borderColor = [UIColor colorWithHex:@"#1AA84A"].CGColor;
            break;
            
        default:
            break;
    }
}

- (void)setDisable:(BOOL)disable{
    _disable = disable;
    if (disable) {
        self.userInteractionEnabled = false;
        UIColor *normalColor = self.bgColor;
        UIColor *titleColor = self.titleColor;
        if (CGColorEqualToColor(titleColor.CGColor, [UIColor colorWithHex:@"#FFFFFF"].CGColor)){
            [self setTitleColor:titleColor forState:UIControlStateNormal];
        }
        else{
            [self setTitleColor:[titleColor colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        }
        [self setBackgroundColor:[normalColor colorWithAlphaComponent:0.5]];
    }
    else{
        self.userInteractionEnabled = true;
        UIColor *normalColor = self.bgColor;
        UIColor *titleColor = self.titleColor;
        [self setTitleColor:[titleColor colorWithAlphaComponent:1] forState:UIControlStateNormal];
        [self setBackgroundColor:[normalColor colorWithAlphaComponent:1]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
