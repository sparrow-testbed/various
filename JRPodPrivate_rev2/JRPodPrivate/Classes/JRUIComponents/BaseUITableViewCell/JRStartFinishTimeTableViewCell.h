//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/21
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRStartFinishTimeTableViewCell : UITableViewCell

/// 开始时间标题
@property (nonatomic,strong)UILabel *startTitleLabel;
/// 开始时间
@property (nonatomic,strong)UILabel *startTimeLabel;
/// 结束时间标题
@property (nonatomic,strong)UILabel *finishTitleLabel;
/// 结束时间
@property (nonatomic,strong)UILabel *finishTimeLabel;

@end

NS_ASSUME_NONNULL_END
