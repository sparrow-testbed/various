/**
 * 所属系统: 新学生考勤
 * 所属模块: 学生考勤 日历
 * 功能描述: 日历Cell
 * 创建时间: 2019/4/16.
 * 维护人:  罗鸿
 * Copyright @ Jerrisoft 2019. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */

#import "JRCalendar.h"

@interface JRAttendanceDIYCalendarCell : JRCalendarCell

@property (weak, nonatomic) UIImageView *circleImageView;

@property (nonatomic,assign) BOOL mark; // 是否标记

@end
