/**
 * 所属系统: 邮件
 * 所属模块: 邮件详情
 * 功能描述: 弹窗
 * 创建时间: 2019/2/28
 * 维护人:  张子飞
 * Copyright @ Jerrisoft 2019. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRActionSheetView : UIView
@property(nonatomic,copy)void (^ClickBlock)(NSInteger clickIndex);


/**
 @desc 根据frame和标题数组初始化View
 @author 张子飞
 @date 2019/2/28
 @param frame fame尺寸
 @param titleArray 标题数组
 @return 返回本例对象
 */
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray;


/**
 @desc 隐藏Sheet
 @author 张子飞
 @date 2019/2/28
 */
- (void)hiddenSheet;

@end

NS_ASSUME_NONNULL_END
