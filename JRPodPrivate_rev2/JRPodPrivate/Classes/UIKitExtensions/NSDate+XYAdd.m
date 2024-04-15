//
//  NSDate+XYAdd.m
//  ArtLibrary
//
//  Created by 徐勇 on 2017/1/16.
//  Copyright © 2017年 徐勇. All rights reserved.
//

#import "NSDate+XYAdd.h"

@implementation NSDate (XYAdd)

// 获取时间戳
+ (NSString *)getTimeSSS {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970] * 1000; // *1000 是精确到毫秒，不乘就是精确到秒
    return [NSString stringWithFormat:@"%.0f", a]; //转为字符型
}

+ (NSString *)getCurrentTime3 {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHH"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
 
}
+ (NSString *)getCurrentTime4{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:[NSDate date]];
}
+ (NSString *)getCurrentTime2 {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy.MM.dd";
    return [formatter stringFromDate:[NSDate date]];
}
+ (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [formatter stringFromDate:date];
}

+ (NSDate *)getDateFromString:(NSString *)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:time];
}

+ (NSString *)getTimeDiffString:(NSDate *)temp {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    unsigned int unitFlag = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    
    // 计算时间差
    NSDateComponents *gap = [cal components:unitFlag fromDate:today toDate:temp options:0];
    
    if (ABS([gap day]) > 0) {
        return [NSString stringWithFormat:@"%@",[temp shortDateTimeString]];
        //  return [NSString stringWithFormat:@"%d天前", ABS([gap day])];
    }else if(ABS([gap hour]) > 0){
        return [NSString stringWithFormat:@"%ld小时前", ABS([gap hour])];
    } else {
        if (ABS([gap minute])==0) {
            return [NSString stringWithFormat:@"刚刚"];
        }
        return [NSString stringWithFormat:@"%ld分钟前",  ABS([gap minute])];
    }
}

- (NSString *)shortDateString {
    static NSDateFormatter *shortDateFormatter = nil;
    if (shortDateFormatter == nil) {
        shortDateFormatter = [NSDateFormatter new];
        [shortDateFormatter setDateFormat:[NSString stringWithFormat:@"MM.dd"]];
        [shortDateFormatter setLocale:[NSLocale currentLocale]];
    }
    return [shortDateFormatter stringFromDate:self];
}

- (NSString *)shortDateTimeString {
    static NSDateFormatter *shortDatetimeFormatter = nil;
    if (shortDatetimeFormatter == nil) {
        shortDatetimeFormatter = [NSDateFormatter new];
        [shortDatetimeFormatter setDateFormat:[NSString stringWithFormat:@"M月d日 HH:mm"]];
        [shortDatetimeFormatter setLocale:[NSLocale currentLocale]];
    }
    return [shortDatetimeFormatter stringFromDate:self];
}

- (NSString *)shortTimeString {
    static NSDateFormatter *shortTimeFormatter = nil;
    if (shortTimeFormatter == nil) {
        shortTimeFormatter = [NSDateFormatter new];
        [shortTimeFormatter setDateFormat:[NSString stringWithFormat:@"HH:mm"]];
        [shortTimeFormatter setLocale:[NSLocale currentLocale]];
    }
    return [shortTimeFormatter stringFromDate:self];
}

- (NSString *)longTimeString {
    static NSDateFormatter *longTimeFormatter = nil;
    if (longTimeFormatter == nil) {
        longTimeFormatter = [NSDateFormatter new];
        [longTimeFormatter setDateFormat:[NSString stringWithFormat:@"HH:mm:ss"]];
        [longTimeFormatter setLocale:[NSLocale currentLocale]];
    }
    return [longTimeFormatter stringFromDate:self];
}

#pragma mark -

+ (NSDateFormatter *)dateFormatter{
    
    static NSDateFormatter *dateFormatter2 = nil;
    if (dateFormatter2 == nil) {
        dateFormatter2 = [NSDateFormatter new];
        [dateFormatter2 setDateFormat:[NSString stringWithFormat:@"yyyy-MM-dd"]];
        [dateFormatter2 setLocale:[NSLocale currentLocale]];
    }
    return dateFormatter2;
}

- (NSString *)dateString {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setLocalizedDateFormatFromTemplate:@"yyyy.MM.dd"];
    }
    return [dateFormatter stringFromDate:self];
}

- (NSString *)dateString2 {
    return [[NSDate dateFormatter] stringFromDate:self];
}

- (NSString *)dateString3 {
    
    NSDateFormatter *dateFormatter1 = [NSDateFormatter new];
    
    [dateFormatter1 setDateFormat:[NSString stringWithFormat:@"yyyy.MM.dd"]];
    
    return [dateFormatter1 stringFromDate:self];
}

- (NSString *)dateTimeString {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"yyyy.MM.dd HH:mm"]];
        [dateFormatter setLocale:[NSLocale currentLocale]];
    }
    return [dateFormatter stringFromDate:self];
}

- (NSString *)dateTimeString2 {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"yyyy-MM-dd HH:mm"]];
        [dateFormatter setLocale:[NSLocale currentLocale]];
    }
    return [dateFormatter stringFromDate:self];
}

#pragma mark -

// 根据生日获取年龄
+ (NSInteger)ageWithDateOfBirth:(NSDate *)date {
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;  // - 1
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth isEqual brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge += 1;
    }
    return iAge;
}

+ (NSDate *)dateWithYear:(int)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    [components setYear:year];
    return [calendar dateFromComponents:components];
}

+ (NSDate *)dateFromYYYYMMDD:(NSString *)dateString {
    return [[self dateFormatter] dateFromString:dateString];
}

- (long long)milseconds {
    NSTimeInterval timeInteval = [self timeIntervalSince1970]*1000;
    return [[NSNumber numberWithDouble:timeInteval] longLongValue];
}

#pragma mark -

- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar calendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 比较年月日
    return selfCmps.year == nowCmps.year && selfCmps.month == nowCmps.month && selfCmps.day == nowCmps.day;
}

- (BOOL)isYesterday {
    // 2015-04-01 10:10:10 -> 2015-04-10 00:00:00
    // 2015-03-31 23:50:40 -> 2015-03-31 00:00:00
    
    // 生成年月日的日期对象
    NSDateFormatter *fmt= [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *selfString = [fmt stringFromDate:self];
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    
    NSDate *selfDate = [fmt dateFromString:selfString];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    NSCalendar *calendar = [NSCalendar calendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    // 比较差距
    NSDateComponents *comps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    return comps.year == 0 && comps.month == 0 && comps.day == 1; //昨天
}

- (BOOL)isTomorrow {
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *selfString = [formatter stringFromDate:self];
    NSString *nowString = [formatter stringFromDate:[NSDate date]];
    
    NSDate *selfDate = [formatter dateFromString:selfString];
    NSDate *nowDate = [formatter dateFromString:nowString];
    
    NSCalendar *calendar = [NSCalendar calendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return comps.year == 0 && comps.month == 0 && comps.day == -1; //明天
}

- (BOOL)isThisYear {
    NSCalendar *calendar = [NSCalendar calendar];
    // 判断年
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];    
    return selfYear isEqual nowYear;
}

// 将NSDate对象转换成时间戳
- (NSString *)toTimeStamp {
    return [NSString stringWithFormat:@"%lf", [self timeIntervalSince1970]];
}

// 将时间戳转换成NSDate对象
+ (NSDate *)toDateWithTimeStamp:(NSString *)timeStamp {
    //    NSString *arg = timeStamp;
    
    //    if (![timeStamp isKindOfClass:[NSString class]]) {
    //        arg = [NSString stringWithFormat:@"%@", timeStamp];
    //    }
    NSTimeInterval time = [timeStamp doubleValue];
    return [NSDate dateWithTimeIntervalSince1970:time];
}

#define D_MINUTE 60
#define D_HOUR   3600
#define D_DAY    86400
#define D_WEEK   604800
#define D_YEAR   31556926

+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setCalendar:gregorian];
    [dateComps setYear:year];
    [dateComps setMonth:month];
    [dateComps setDay:day];
    [dateComps setTimeZone:systemTimeZone];
    [dateComps setHour:hour];
    [dateComps setMinute:minute];
    [dateComps setSecond:second];
    
    return [dateComps date];
}

+ (NSInteger)daysOffsetBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate  toDate:endDate  options:0];
    NSInteger days = [comps day];
    return days;
}

+ (NSDate *)dateWithHour:(int)hour
                  minute:(int)minute {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:hour];
    [components setMinute:minute];
    NSDate *newDate = [calendar dateFromComponents:components];
    return newDate;
}

#pragma mark - Data component
- (NSInteger)year {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [dateComponents year];
}

- (NSInteger)month {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [dateComponents month];
}

- (NSInteger)day {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [dateComponents day];
}

- (NSInteger)hour {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [dateComponents hour];
}

- (NSInteger)minute {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [dateComponents minute];
}

- (NSInteger)second {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [dateComponents second];
}

- (NSString *)weekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”）
    NSString *week = nil;
    switch (weekday) {
        case 1:
            week = @"星期日";
            break;
        case 2:
            week = @"星期一";
            break;
        case 3:
            week = @"星期二";
            break;
        case 4:
            week = @"星期三";
            break;
        case 5:
            week = @"星期四";
            break;
        case 6:
            week = @"星期五";
            break;
        case 7:
            week = @"星期六";
            break;
            
        default:
            break;
    }
    
    return week;
}

- (NSString *)weekday2 {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal fromDate:self];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”）
    NSString *week = nil;
    switch (weekday) {
        case 1:
            week = @"周日";
            break;
        case 2:
            week = @"周一";
            break;
        case 3:
            week = @"周二";
            break;
        case 4:
            week = @"周三";
            break;
        case 5:
            week = @"周四";
            break;
        case 6:
            week = @"周五";
            break;
        case 7:
            week = @"周六";
            break;
            
        default:
            break;
    }
    
    return week;
}

#pragma mark - Time string
- (NSString *)timeHourMinute {
    return [self timeHourMinuteWithPrefix:NO suffix:NO];
}

- (NSString *)timeHourMinuteWithPrefix {
    return [self timeHourMinuteWithPrefix:YES suffix:NO];
}

- (NSString *)timeHourMinuteWithSuffix {
    return [self timeHourMinuteWithPrefix:NO suffix:YES];
}

- (NSString *)timeHourMinuteWithPrefix:(BOOL)enablePrefix suffix:(BOOL)enableSuffix {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [formatter stringFromDate:self];
    if (enablePrefix) {
        timeStr = [NSString stringWithFormat:@"%@%@",([self hour] > 12 ? @"下午" : @"上午"),timeStr];
    }
    if (enableSuffix) {
        timeStr = [NSString stringWithFormat:@"%@%@",([self hour] > 12 ? @"pm" : @"am"),timeStr];
    }
    return timeStr;
}

#pragma mark - Date String
- (NSString *)stringTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *str = [formatter stringFromDate:self];
    return str;
}

- (NSString *)stringMonthDay {
    return [NSDate dateMonthDayWithDate:self];
}

- (NSString *)stringYearMonthDay {
    return [NSDate stringYearMonthDayWithDate:self];
}

- (NSString *)stringYearMonthDayHourMinuteSecond {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [formatter stringFromDate:self];
    return str;
}

- (NSString *)stringYearMonthDayCompareToday {
    NSString *str;
    NSInteger chaDay = [self daysBetweenCurrentDateAndDate];
    if (chaDay isEqual 0) {
        str = @"Today";
    }else if (chaDay isEqual 1){
        str = @"Tomorrow";
    }else if (chaDay isEqual -1){
        str = @"Yesterday";
    } else {
        str = [self stringYearMonthDay];
    }
    
    return str;
}

+ (NSString *)stringLoacalDate {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSString *dateStr = [format stringFromDate:localeDate];
    
    return dateStr;
}

+ (NSString *)stringYearMonthDayWithDate:(NSDate *)date {
    if (date == nil) {
        date = [NSDate date];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

+ (NSString *)dateMonthDayWithDate:(NSDate *)date {
    if (date == nil) {
        date = [NSDate date];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM.dd"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

#pragma mark - Date formate

+ (NSString *)dateFormatString {
    return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
    return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
    return @"yyyy-MM-dd HH:mm:ss";
}

+ (NSString *)timestampFormatStringSubSeconds {
    return @"yyyy-MM-dd HH:mm";
}

#pragma mark - Date adjust
- (NSDate *)dateByAddingDays:(NSInteger)dDays {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingDays:(NSInteger)dDays {
    return [self dateByAddingDays: (dDays * -1)];
}

#pragma mark - Relative Dates
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days {
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days {
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *)dateTomorrow {
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *)dateYesterday {
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal) fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal) fromDate:aDate];
    
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

+ (NSDate *)dateStandardFormatTimeZeroWithDate:(NSDate *)aDate {
    NSString *str = [[NSDate stringYearMonthDayWithDate:aDate]stringByAppendingString:@" 00:00:00"];
    NSDate *date = [NSDate dateFromString:str];
    return date;
}

- (NSInteger)daysBetweenCurrentDateAndDate {
    //只取年月日比较
    NSDate *dateSelf = [NSDate dateStandardFormatTimeZeroWithDate:self];
    NSTimeInterval timeInterval = [dateSelf timeIntervalSince1970];
    NSDate *dateNow = [NSDate dateStandardFormatTimeZeroWithDate:nil];
    NSTimeInterval timeIntervalNow = [dateNow timeIntervalSince1970];
    
    NSTimeInterval cha = timeInterval - timeIntervalNow;
    CGFloat chaDay = cha / 86400.0;
    NSInteger day = chaDay * 1;
    return day;
}

#pragma mark - Date and string convert
+ (NSDate *)dateFromString:(NSString *)string {
    return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

- (NSString *)string {
    return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringCutSeconds
{
    return [self stringWithFormat:[NSDate timestampFormatStringSubSeconds]];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    return timestamp_str;
}

+ (NSString *)dbFormatString {
    return [NSDate timestampFormatString];
}


// =====================================================

- (void)test {
    
    //得到当前的UTC时间 和我们时间相差8个小时
    NSDate* date = [[NSDate alloc]init];
    NSLog(@"date:%@",date);
    //相隔的时间 单位：秒
    NSDate* tomorrow = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    NSDate* yesterday = [NSDate dateWithTimeIntervalSinceNow:-60*60*24];
    NSLog(@"tomorrow:%@",tomorrow);
    NSLog(@"yesterday:%@",yesterday);
    
    //日期模板对象
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    //设置日期模板 日期输出的格式
    //hh小时:mm分钟:ss秒 yyyy年:MM月:dd日
    //hh12小时制 HH24小时制
    dateFormatter.dateFormat = @"MM月dd日yyyy年 hh:mm:ss";
    //通过日期模板对象，将指定的日期转换为：
    //处理好时区、显示格式的字符串
    NSString* dateStr = [dateFormatter stringFromDate:date];
    NSLog(@"dateStr:%@",dateStr);
    //求差
    NSString* str = @"10";
    int s1 = [str intValue];//对象类型解封为基本类型
    NSString* str2 = @"5";
    int s2 = [str2 intValue];
    int i = s1-s2;
    NSLog(@"i:%d",i);//i:5
    
    //获得世界标准时间
    NSDate *today = [[NSDate alloc] init];
    NSLog(@"%@", today);
    //获得本地时间
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    dFormatter.dateFormat = @"yyyy年MM月dd日 hh:mm:ss";
    NSLog(@"%@", [dFormatter stringFromDate:today]);
    
    //获得当前时间的前后若干秒的时间值
    NSDate *date1 = [NSDate dateWithTimeIntervalSinceNow:-60];
    NSLog(@"%@", date1);
    NSDate *date2 = [NSDate dateWithTimeIntervalSinceNow:60];
    NSLog(@"%@", date2);
    
    //获得自1970年1月1日0时到现在已经过去的秒数
    NSTimeInterval seconds = [today timeIntervalSince1970];
    NSLog(@"%f", seconds);
    
    //获得指定时间距现在的秒数
    NSTimeInterval seconds1 = [date2 timeIntervalSinceNow];
    NSLog(@"%f", seconds1);
    
    //获得两个指定时间之间的秒数
    NSTimeInterval seconds2 = [date1 timeIntervalSinceDate:date2];
    NSLog(@"%f", seconds2);
    
    //比较两个时间，哪个更早
    NSDate* earlierDate = [date1 earlierDate:date2];
    NSLog(@"%@", earlierDate);
    //哪个更晚
    NSDate* laterDate = [date1 laterDate:date2];
    NSLog(@"%@", laterDate);
    //是否相同
    if ([date1 isEqualToDate:date2]) {
        NSLog(@"是同一时间");
    }else {
        NSLog(@"不是同一时间");
    }
}

/*
 
 NSDate 日期
 NSDate存储的是时间信息，默认存储的是世界标准时间(UTC)，输出时需要根据时区转换为本地时间。中国大陆、香港、澳门、台湾…的时间增均与UTC时间差为+8，也就是UTC+8。
 NSDate* date = [[NSDate alloc]init];//初始化 得到当前的时间
 NSDate*date2= [NSDate dateWithTimeIntervalSinceNow:30];//得到一个时间，和当前比延迟30秒
 NSTimeInterval second = [date timeIntervalSince1970];//和当前时间对比 返回秒数
 NSDate* earlierDate = [date earlierDate:date2]; //比较两个时间 哪个更早
 NSDate* laterDate = [date laterDate:date2];//比较两个时间 哪个更晚
 
 */

/*
 NSDate *date = [NSDate date];
 NSString timeStamp = [date hyb_toTimeStamp];
 
 NSDate *date = [NSDate hyb_toDateWithTimeStamp:timeStamp];
 */


@end
