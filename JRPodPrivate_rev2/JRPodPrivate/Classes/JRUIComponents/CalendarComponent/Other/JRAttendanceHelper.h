//
//  JRAttendanceHelper.h
//  ManagementPlatform
//
//  Created by 徐勇 on 2018/3/16.
//  Copyright © 2018年 ITUser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRAttendanceCourseModel.h"

@interface JRAttendanceHelper : NSObject

+ (NSString *)getWeekdayWithTime:(NSString *)time;

+ (NSString *)getCourseTime:(JRAttendanceCourseModel *)classModel;

/// 比较两个日期的先后
+ (int)compareDateWithDate1:(NSDate *)date1 date2:(NSDate *)date2;

@end
