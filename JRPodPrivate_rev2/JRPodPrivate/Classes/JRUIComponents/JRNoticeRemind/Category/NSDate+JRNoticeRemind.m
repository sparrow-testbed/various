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

#import "NSDate+JRNoticeRemind.h"

@implementation NSDate (JRNoticeRemind)

+ (NSString *)dateSwitchFormater:(NSString*)formatter toFormatter:(NSString *)toFormatter dateStr:(NSString*)dateStr {

    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:formatter];
    NSDate *inputDate = [inputFormatter dateFromString:dateStr];

    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:toFormatter];
    NSString *timeChanged = [outputFormatter stringFromDate:inputDate];

    return timeChanged;
}

@end
