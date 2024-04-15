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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    JRPrincipalButtonStatus,//主要按钮
    JRSecondaryButtonStatus,//次要按钮
    JRDangerButtonStatus,//危险按钮
    JRSegmentNormalButtonStatus,//选项卡通用状态
    JRSegmentSelectButtonStatus,//选项卡选择状态
    JRYearsNormalButtonStatus,//选择年通用状态
    JRYearsSelectButtonStatus,//选择年选择状态

} JRButtonStatus;

@interface JRUIButton : UIButton
//背景颜色
@property (nonatomic,strong)UIColor *bgColor;
//阴影颜色
@property (nonatomic,strong)UIColor *shadowColor;
//标题
@property (nonatomic,copy)NSString *title;
//标题颜色
@property (nonatomic,strong)UIColor *titleColor;
//标题文字大小
@property (nonatomic,strong)UIFont *titleFont;

//边框颜色
@property (nonatomic,strong)UIColor *borderColor;

//边框宽度
@property (nonatomic,assign)CGFloat borderWidth;

//是否禁用
@property (nonatomic,assign)BOOL disable;
/// 按钮状态
@property (nonatomic,assign)JRButtonStatus buttonStatus;

- (void)removeVi;
@end

NS_ASSUME_NONNULL_END
