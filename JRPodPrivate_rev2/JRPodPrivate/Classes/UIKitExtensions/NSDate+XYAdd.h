//
//  NSDate+XYAdd.h
//  ArtLibrary
//
//  Created by 徐勇 on 2017/1/16.
//  Copyright © 2017年 徐勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSCalendar+XYAdd.h"

@interface NSDate (XYAdd)

// 获取时间戳 毫秒级
+ (NSString *)getTimeSSS;
+ (NSString *)getCurrentTime4;
+ (NSString *)getCurrentTime3;
+ (NSString *)getCurrentTime2;
+ (NSString *)getCurrentTime;
+ (NSString *)dateToString:(NSDate *)date;
+ (NSDate *)getDateFromString:(NSString *)time;
+ (NSString *)getTimeDiffString:(NSDate *)temp;

- (NSString *)shortDateString;
- (NSString *)shortTimeString;
- (NSString *)longTimeString;
- (NSString *)shortDateTimeString;
- (NSString *)dateString;
- (NSString *)dateString2;
- (NSString *)dateString3;
- (NSString *)dateTimeString;
- (NSString *)dateTimeString2;

// 根据生日获取年龄
+ (NSInteger)ageWithDateOfBirth:(NSDate *)date;
+ (NSDate *)dateWithYear:(int)year;
+ (NSDate *)dateFromYYYYMMDD:(NSString *)dateString;

- (long long)milseconds;
- (BOOL)isToday;
- (BOOL)isYesterday;
- (BOOL)isTomorrow;
- (BOOL)isThisYear;

#pragma mark -

+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second;

+ (NSInteger)daysOffsetBetweenStartDate:(NSDate *)startDate
                                endDate:(NSDate *)endDate;

+ (NSDate *)dateWithHour:(int)hour
                  minute:(int)minute;

#pragma mark - Getter
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
- (NSString *)weekday;
- (NSString *)weekday2;

#pragma mark - Time string
- (NSString *)timeHourMinute;
- (NSString *)timeHourMinuteWithPrefix;
- (NSString *)timeHourMinuteWithSuffix;
- (NSString *)timeHourMinuteWithPrefix:(BOOL)enablePrefix suffix:(BOOL)enableSuffix;

#pragma mark - Date String
- (NSString *)stringTime;
- (NSString *)stringMonthDay;
- (NSString *)stringYearMonthDay;
- (NSString *)stringYearMonthDayHourMinuteSecond;
+ (NSString *)stringYearMonthDayWithDate:(NSDate *)date;   //date为空时返回的是当前年月日
+ (NSString *)stringLoacalDate;

#pragma mark - Date formate
+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)timestampFormatStringSubSeconds;

#pragma mark - Date adjust
- (NSDate *)dateByAddingDays:(NSInteger)dDays;
- (NSDate *)dateBySubtractingDays:(NSInteger)dDays;

#pragma mark - Relative dates from the date
+ (NSDate *)dateTomorrow;
+ (NSDate *)dateYesterday;
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days;
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days;
+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours;
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours;
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes;
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes;
+ (NSDate *)dateStandardFormatTimeZeroWithDate:(NSDate *)aDate;  //标准格式的零点日期
- (NSInteger)daysBetweenCurrentDateAndDate;                     //负数为过去，正数为未来

#pragma mark - Date compare
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate;
- (NSString *)stringYearMonthDayCompareToday;         //返回“今天”，“明天”，“昨天”，或年月日

#pragma mark - Date and string convert
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
- (NSString *)string;
- (NSString *)stringCutSeconds;

@end
