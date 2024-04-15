//
/**
* 所属系统: component
* 所属模块: UIView
* 功能描述: 基础选型卡
* 创建时间: 2020/9/22
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SegmentBlock)(UIButton *button,NSInteger idx);

@interface JRSegmentView : UIView
/// 默认颜色
@property (nullable, nonatomic,strong)UIColor *defaultColor;
//选中颜色
@property (nullable, nonatomic,strong)UIColor *selectColor;
//字体大小
@property (nullable, nonatomic,strong)UIFont *textFont;
//数据源
@property (nonatomic,copy)NSArray *dataSource;
//是否展示下划线
@property (nonatomic,assign)BOOL showLine;
//下划线
@property (nonatomic,strong)UIView *dividedView;
//选中按钮
@property (nonatomic,strong)UIButton *selectButton;

@property (nonatomic,copy)SegmentBlock segmentBlock;


/// 初始化标签View
/// @param frame frame description
/// @param dataSource 数据源
/// @param showLine 是否展示竖线分割线
/// @param textFont 字体大小
/// @param defaultColor 默认颜色
/// @param selectColor 选中颜色
- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource showLine:(BOOL)showLine textFont:(nullable UIFont *)textFont defaultColor:(nullable UIColor *)defaultColor selectColor:(nullable UIColor *)selectColor;
@end

NS_ASSUME_NONNULL_END
