//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/17
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRAdjustToolBar.h"
#import "JRUIKit.h"
@interface JRAdjustToolBar ()

@property (nonatomic, strong)UIView *sliderBagView;
@property (nonatomic, strong)UIButton *button;


@end

@implementation JRAdjustToolBar
{
    float _minSliderValue;
    float _maxSliderValue;
    float _currentSliderValue;

}
+ (CGFloat)fixedHeight
{
    return 80;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _minSliderValue = -0.25;
        _maxSliderValue =  0.25;
        _currentSliderValue = 0.0;
        //默认初始值
        self.brightnessValue = 0.0;
        self.contrastValue = 1.25;
        self.saturationValue = 1.25;
        
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        
        self.sliderBagView =  [self buildSliderBagView];
        [self createViewButton];
        
        
    }
    return self;
}


- (UIView *)buildSliderBagView {
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 40)];
    [self addSubview:buttonView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    self.labelStr = titleLabel;
    titleLabel.tag = 9997;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"0";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [buttonView addSubview:titleLabel];
    
    /// 创建Slider 设置Frame
    JRCustomSlider *slider = [[JRCustomSlider alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH * 0.7, 40)];
    self.slider = slider;
    /// 添加Slider
    [buttonView addSubview:slider];
    
    /// 属性配置
    // minimumValue  : 当值可以改变时，滑块可以滑动到最小位置的值，默认为0.0
    slider.minimumValue = _minSliderValue;
    // maximumValue : 当值可以改变时，滑块可以滑动到最大位置的值，默认为1.0
    slider.maximumValue = _maxSliderValue;
    // 当前值，这个值是介于滑块的最大值和最小值之间的，如果没有设置边界值，默认为0-1；
    slider.value = _currentSliderValue;
    
    [slider setContinuous:YES];
        
    // minimumTrackTintColor : 小于滑块当前值滑块条的颜色，默认为蓝色
    slider.minimumTrackTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
    // maximumTrackTintColor: 大于滑块当前值滑块条的颜色，默认为白色
    slider.maximumTrackTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
    // thumbTintColor : 当前滑块的颜色，默认为白色
    slider.thumbTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    /// 事件监听
    [slider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setImage:[JRUIHelper imageNamed:@"i_return_big_nor"] forState:UIControlStateNormal];
    self.button.enabled = NO;
    [buttonView addSubview:self.button];
    [self.button addTarget:self action:@selector(backLastType:) forControlEvents:UIControlEventTouchUpInside];

    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(slider.mas_right).offset(10);
        make.centerY.mas_equalTo(slider.mas_centerY);
        make.width.height.equalTo(@40);
    }];
    
    return  buttonView;
}

- (UIView *)createViewButton {
    
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH , 40)];
    buttonView.tag = 9998;
    [self addSubview:buttonView];
    float buttonW = 80;
    float buttonX = SCREEN_WIDTH/2 - (buttonW + buttonW/2);
    
   
    
    for (int i = 0; i<3; i++) {
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setTitle:([self btnNames][i]) forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:16];
        [button1 setTitleEdgeInsets:UIEdgeInsetsMake(-13, 0, 0, 0)];
        
        UIView *roundView = [[UIView alloc]initWithFrame:CGRectMake(buttonW/2-10, 40/2+5, 5, 5)];
        roundView.backgroundColor = [UIColor greenColor];
        roundView.tag = 700;
        roundView.layer.cornerRadius = 2.5;
        [button1 addSubview:roundView];
        
        button1.tag = i;
        if (i == 0)  button1.selected = YES;
        if (@available(iOS 11.0, *)) {
            [button1 setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        } else {
            // Fallback on earlier versions
        }
        
        if (button1.selected) {
            roundView.alpha = 1;
        }else {
            roundView.alpha = 0;
        }
        
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button1 setFrame:CGRectMake(buttonX*(i+1)+25, 0, 60, 40)];
        [button1 addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:button1];
    }
    return buttonView;
}
//返回上一次状态
- (void)backLastType:(UIButton *)sender {
//    self.backAdjustType();
    if (self.adjustTypeBlock) {
        
        switch (self.adjustType) {
            case 0:
            {
                self.adjustTypeBlock(self.adjustType,0.0f);
                self.slider.value = 0.0;
                self.button.enabled = NO;

                break;
            }
            case 1:
            {
                self.adjustTypeBlock(self.adjustType,1.25f);
                self.slider.value = 1.25;
                self.button.enabled = NO;

                break;
            }
            case 2:
            {
                self.adjustTypeBlock(self.adjustType,1.25f);
                self.slider.value = 1.25;
                self.button.enabled = NO;

                break;
            }
                
            default:
                break;
        }
    }
}

- (void)selectItem:(UIButton *)sender {
    UIView *buttonView = [self viewWithTag:9998];
    for (UIButton *btn in buttonView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            
            UIView *roundView = [btn viewWithTag:700];
            
            if (btn == sender) {
                sender.selected = YES;
                roundView.alpha = 1;
            }else {
                btn.selected = NO;
                roundView.alpha = 0;
            }
        }
    }
    
    self.adjustType = sender.tag;
    if (sender.tag == 0) {
        // 亮度
        self.slider.minimumValue = -0.25;
        self.slider.maximumValue = 0.25;
        
        if (self.brightnessValue != 0.0) {
            self.slider.value = self.brightnessValue;
            self.labelStr.text = [NSString stringWithFormat:@"%.0f",(self.brightnessValue*400)];
            self.button.enabled = YES;
        }else {
            self.slider.value = 0.0;
            self.labelStr.text = [NSString stringWithFormat:@"%.0f",(self.slider.value*400)];
            self.button.enabled = NO;
        }

        
    }else  if (sender.tag == 1) {
        //对比度 0 - 2
        self.slider.minimumValue = 0.5;
        self.slider.maximumValue = 2.0;
        if (self.contrastValue != 1.25) {
            self.slider.value = self.contrastValue;
            self.button.enabled = YES;

        }else {
            self.slider.value = 1.25;
            self.button.enabled = NO;

        }
        [self setLabelStrWithSliderValue:self.contrastValue];
    }else{
        // 饱和度 0 - 2
        self.slider.minimumValue = 0.5;
        self.slider.maximumValue = 2.0;
        
        if (self.saturationValue != 1.25) {
            self.slider.value = self.saturationValue;
            self.button.enabled = YES;

        }else {
            self.slider.value = 1.25;
            self.button.enabled = NO;

        }
  
        [self setLabelStrWithSliderValue:self.saturationValue];
    }
}


- (void)setLabelStrWithSliderValue:(float)sliderValue {
    if (sliderValue<=1.25) {
        float tempA = 0.0;
        if (sliderValue == 1.25) {
            tempA = ( 1.25 - sliderValue)*-100;
        }else {
            tempA = ( 1.25 - sliderValue )*-100 - 25;
        }
        if (tempA == 0) {
            self.labelStr.text = @"0";
        }else {
            self.labelStr.text = [NSString stringWithFormat:@"%.0f",tempA];
        }

    }else {
        float tempA =  (sliderValue - 1)*100;
        self.labelStr.text = [NSString stringWithFormat:@"%.0f",tempA];
    }
}

- (NSArray *)btnNames {
    return @[@"亮度",@"对比度",@"饱和度"];
}

- (void)sliderValueDidChanged:(UISlider *)slider {
    NSLog(@"%.2f",slider.value);
    self.button.enabled  = YES;
    if (self.adjustTypeBlock) {
        self.adjustTypeBlock(self.adjustType,slider.value);
    }
    
}


@end
