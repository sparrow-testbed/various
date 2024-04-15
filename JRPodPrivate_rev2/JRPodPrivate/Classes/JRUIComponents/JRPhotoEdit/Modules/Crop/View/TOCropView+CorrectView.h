//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/4/8
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TOCropView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TOCropView (CorrectView)

@property (nonatomic, strong)  UIView *topLeftControl;
@property (nonatomic, strong)  UIView *topRightControl;
@property (nonatomic, strong)  UIView *bottomLeftControl;
@property (nonatomic, strong)  UIView *bottomRightControl;

@property (nonatomic, assign)  float buttonWidth;


- (void) buildCorrectView;

- (void) restControlView;

@end

NS_ASSUME_NONNULL_END
