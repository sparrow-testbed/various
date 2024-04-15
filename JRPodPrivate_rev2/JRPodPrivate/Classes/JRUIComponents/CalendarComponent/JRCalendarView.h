//
//  JRCalendarView.h
//  JRPodPrivate_Example
//
//  Created by 李志龑 on 2020/9/27.
//  Copyright © 2020 wni. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRCalendarView : UIView

@property (nonatomic, assign) BOOL isWeekCalendar;//是否只显示周日历

@property (nonatomic, strong) NSString *titleName;//日历标题名
//@property (nonatomic, strong) UIColor *titleDefaultColor;//默认字体颜色
//@property (nonatomic, strong) UIColor *titleTodayColor;//今天字体颜色
//@property (nonatomic, strong) UIColor *titleSelectorColor;//选中字体颜色
//@property (nonatomic, strong) UIColor *selectionColor;//选中颜色

@property (nonatomic, strong) NSArray *courseArr; // 有事件日期 包含AttendanceSemesterModel数组
@property (nonatomic, copy) void (^ clickBackBlock)();
@property (nonatomic, copy) void (^ choiceDay)(NSString *dateString);

@property (nonatomic, copy) void (^ reloadHeight)(CGFloat height);
@end

NS_ASSUME_NONNULL_END
