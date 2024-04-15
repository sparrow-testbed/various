//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/26
* 维护人:  李志䶮
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "NSString+JRNoticeRemind.h"
#import "NSDate+JRNoticeRemind.h"
#import "JRUIKit.h"

@implementation NSString (JRNoticeRemind)

/// 年月日时间小于10两位变一位
/// @param timeString 时间字符串
+ (NSString *)dateStringRemoveZero:(NSString *)timeString{
    if ([timeString containsString:@"年"]) {
        return  [NSDate dateSwitchFormater:@"yyyy年MM月dd日 HH:mm" toFormatter:@"yyyy年M月d日 HH:mm" dateStr:timeString];
    }else{
        return  [NSDate dateSwitchFormater:@"MM月dd日 HH:mm" toFormatter:@"M月d日 HH:mm" dateStr:timeString];
    }
    
}

/*
    1.今天 例：今天 hh:mm
    2.昨天 例：昨天 hh:mm
    3.前天 例：xx月xx日 hh:mm
    4.去年 例：xxxx年xx月xx日 hh:mm
 
    时间参数为时间戳
 */
+ (NSString *)changeTimeStamp:(NSInteger)timeStamp{
    NSString *showTimeString;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    if (date.isToday) {
        //今天
        [inputFormatter setDateFormat:@"HH:mm"];
        NSString *timeString = [inputFormatter stringFromDate:date];
        showTimeString = [NSString stringWithFormat:@"%@ %@",@"今天",timeString];
    }
    else if (date.isYesterday){
        //昨天
        [inputFormatter setDateFormat:@"HH:mm"];
        NSString *timeString = [inputFormatter stringFromDate:date];
        showTimeString = [NSString stringWithFormat:@"%@ %@",@"昨天",timeString];
    }
    else if (date.jk_isThisYear){
        //今年
        [inputFormatter setDateFormat:@"MM月dd日 HH:mm"];
        NSString *timeString = [inputFormatter stringFromDate:date];
        showTimeString = [NSString stringWithFormat:@"%@",timeString];
    }
    else{
        //其他年
        [inputFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        NSString *timeString = [inputFormatter stringFromDate:date];
        showTimeString = [NSString stringWithFormat:@"%@",timeString];
    }
    
    return showTimeString;
}

@end
