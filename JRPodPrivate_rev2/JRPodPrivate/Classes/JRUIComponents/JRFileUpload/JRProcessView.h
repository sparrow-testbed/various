//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/1/18
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>
#import "JRUIKit.h"

typedef void(^ZRCompletionBlock)(void);


typedef enum : NSUInteger {
    JRProcessCircle = 0,
    JRProcessLine,
} JRProcessType;

NS_ASSUME_NONNULL_BEGIN

@interface JRProcessView : UIView
@property (nonatomic) CGFloat progressHeight;

@property (nonatomic) CGFloat progressValue;

@property (nonatomic, strong) UIColor *changeTintColor;

@property (nonatomic, strong) UIColor *progressTintColor;

@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) CGFloat progressWidth;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) ZRCompletionBlock completionBlock;

- (instancetype)initWithFrame:(CGRect)frame withProcessType:(JRProcessType)processType;

@end

NS_ASSUME_NONNULL_END
