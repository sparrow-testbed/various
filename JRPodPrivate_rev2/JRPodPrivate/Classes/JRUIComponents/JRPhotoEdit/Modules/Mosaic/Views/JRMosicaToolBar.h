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
#import "JRMosicaButton.h"
typedef NS_ENUM(NSUInteger, JRMosicaStyle)
{
    JRMosicaStyleNormal,
};

typedef void (^JRMosicaToolClickBlock)(UIButton *btn);
typedef void (^JRMosicaToolLineWidthBlock)(NSInteger brushSizeWidth);

typedef void (^JRMosicaStyleClickBlock)(UIButton *btn, JRMosicaStyle style);

NS_ASSUME_NONNULL_BEGIN

@interface JRMosicaToolBar : UIView

@property (weak, nonatomic) IBOutlet JRMosicaButton *backButton;

@property (strong, nonatomic) IBOutletCollection(JRMosicaButton) NSArray *colorButtons;

@property (nonatomic, assign) float brushSizeWith;

@property (nonatomic, copy) JRMosicaToolClickBlock backButtonClickBlock;
@property (nonatomic, copy) JRMosicaStyleClickBlock mosicaStyleButtonClickBlock;

@property (nonatomic, copy) JRMosicaToolLineWidthBlock lineWidthClickBlock;

+ (CGFloat)fixedHeight;

@end

NS_ASSUME_NONNULL_END
