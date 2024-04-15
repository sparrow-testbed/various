//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/25
* 维护人:  李志䶮
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>
#import "JRNoticeRemindModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JRNoticeRemindTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UIView *bgView;//背景
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *headerLabel;//头部内容
@property (nonatomic, strong) UILabel *bottomLabel;//底部内容
@property (nonatomic, strong) UIView *lineLabel;//横线
@property (nonatomic, strong) UIButton *enterDetailButton;//查看详情
@property (nonatomic, strong) UIImageView *rightImageView;//箭头
@property (nonatomic, strong) UITableView *contentTableView;//内容视图

@property (nonatomic, strong) JRNoticeRemindModel *model;
@property (nonatomic, copy) void (^ enterDetailBlock)(JRNoticeRemindTableViewCell * );

@end

NS_ASSUME_NONNULL_END
