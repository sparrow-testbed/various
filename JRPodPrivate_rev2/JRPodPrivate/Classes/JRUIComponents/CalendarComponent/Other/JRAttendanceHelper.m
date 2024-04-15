//
//  JRAttendanceHelper.m
//  ManagementPlatform
//
//  Created by 徐勇 on 2018/3/16.
//  Copyright © 2018年 ITUser. All rights reserved.
//

#import "JRAttendanceHelper.h"
#import "JRUIKit.h"

@implementation JRAttendanceHelper

+ (NSString *)getWeekdayWithTime:(NSString *)time {
    
    if ([time isEqualToString:@"0"]) {
        return @"周日";
    } else if ([time isEqualToString:@"1"]) {
        return @"周一";
    } else if ([time isEqualToString:@"2"]) {
        return @"周二";
    } else if ([time isEqualToString:@"3"]) {
        return @"周三";
    } else if ([time isEqualToString:@"4"]) {
        return @"周四";
    } else if ([time isEqualToString:@"5"]) {
        return @"周五";
    } else if ([time isEqualToString:@"6"]) {
        return @"周六";
    } else {
        return nil;
    }
}

+ (NSString *)getCourseTime:(JRAttendanceCourseModel *)classModel {
    
    if (classModel.classTime.length < 10) {
        return nil;
    }
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"yyyy.MM.dd";
    
    NSString *weekStr = classModel.week ? classModel.week : [classModel.date weekday2];
    NSString *dateStr = [NSString stringWithFormat:@"%@ (%@) %@",[dateFormater stringFromDate:classModel.date], weekStr,classModel.classTime];
    return dateStr;
}

+ (int)compareDateWithDate1:(NSDate *)date1 date2:(NSDate *)date2  {
    
    int result = [date1 compare:date2];
    if(result == NSOrderedDescending) {
        return 1;
    } else if(result == NSOrderedAscending) {
        return -1;
    }
    return 0;
}

@end
