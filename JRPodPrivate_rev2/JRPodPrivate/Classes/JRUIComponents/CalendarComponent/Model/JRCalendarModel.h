//
//  AttendanceSemesterModel.h
//  ManagementPlatform
//
//  Created by 李志䶮 on 2020/9/19.
//  Copyright © 2020年 ITUser. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 学期信息
 */
@interface JRCalendarModel : NSObject

@property (nonatomic, copy) NSString *dateString; //日期
@property (nonatomic, assign) BOOL mark; // YES 标记看过 NO 标记没看过

@end
