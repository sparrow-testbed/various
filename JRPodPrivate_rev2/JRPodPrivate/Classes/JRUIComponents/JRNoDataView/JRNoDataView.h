//
/**
* 所属系统: 移动组件
* 所属模块: 空数据页面
* 功能描述: 
* 创建时间: 2020/9/21
* 维护人:  李志䶮
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRNoDataView : UIView
//占位图
@property (nonatomic,strong)UIImageView *placeholderImageV;
//占位文字
@property (nonatomic,strong)UILabel *placeholderLabel;


/// 弹出空白弹窗
/// @param superView 被添加的View
/// @param noDataImageName 空白图片名
/// @param noDataTitle 空白标题
/// @param topInset 距离顶部距离
+(void)showNodataWithSuperView:(UIView*)superView noDataImageName:(nullable NSString *)noDataImageName noDataTitle:(nullable NSString *)noDataTitle topInset:(CGFloat)topInset;
/// 弹出空白弹窗
/// @param superView 被添加的View
/// @param noDataImageName 空白图片名
/// @param noDataTitle 空白标题
+(void)showNodataWithSuperView:(UIView*)superView noDataImageName:(nullable NSString *)noDataImageName noDataTitle:(nullable NSString *)noDataTitle;

/// 隐藏空白界面
/// @param superView 被添加的View
+(void)hidNodataWithSuperView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
