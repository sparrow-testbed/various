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

#import <UIKit/UIKit.h>
#import "JRCustomSlider.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    AdjustBrightness = 0, // 亮度
    AdjustContrast,//对比度
    AdjustSaturability,//饱和度
} AdjustType;

typedef void(^AdjustTypeBlock)(AdjustType adjustType,float sliderValue);
typedef void(^BackAdjustType)(void);

@interface JRAdjustToolBar : UIView

@property (nonatomic, strong) JRCustomSlider *slider;
@property (nonatomic, assign) AdjustType adjustType;
@property (nonatomic, copy) AdjustTypeBlock adjustTypeBlock;
@property (nonatomic, copy) BackAdjustType backAdjustType;
@property (nonatomic, assign) float brightnessValue;//  亮度
@property (nonatomic, assign) float saturationValue;// 饱和度
@property (nonatomic, assign) float contrastValue;// 对比度
@property (nonatomic, strong)UILabel *labelStr;


+ (CGFloat)fixedHeight;

- (void)setLabelStrWithSliderValue:(float)sliderValue;

@end

NS_ASSUME_NONNULL_END
