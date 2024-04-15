//
//  JRAttendanceCourseModel.m
//  ManagementPlatform
//
//  Created by 徐勇 on 2018/3/14.
//  Copyright © 2018年 ITUser. All rights reserved.
//

#import "JRAttendanceCourseModel.h"

@implementation JRAttendanceCourseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"claTTSNo"        : @"ClaTTSNo",
             @"claListSNo"      : @"ClaListSNo",
             @"claListID"       : @"ClaListID",
             @"cListName"       : @"CListName",
             @"timeFr"          : @"TimeFr",
             @"timeTo"          : @"TimeTo",
             @"classDate"       : @"ClassDate",
             @"doWeek"          : @"DoWeek",
             @"cRoomID"         : @"CRoomID",
             @"cRoomName"       : @"CRoomName",
             @"empSno"          : @"EmpSno",
             @"empId"           : @"EmpId",
             @"empName"         : @"EmpName",
             @"count"           : @"AbnormalCnt"
             };
}

@end
