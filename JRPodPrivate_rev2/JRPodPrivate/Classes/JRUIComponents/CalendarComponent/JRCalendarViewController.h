//
/**
* 所属系统: 移动组件
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/19
* 维护人:  李志䶮
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRCalendarViewController : UIViewController

@property (nonatomic, assign) BOOL isWeekCalendar;//是否只显示周日历

@property (nonatomic, strong) NSArray *courseArr; // 有事件日期 包含AttendanceSemesterModel数组



@end

NS_ASSUME_NONNULL_END
