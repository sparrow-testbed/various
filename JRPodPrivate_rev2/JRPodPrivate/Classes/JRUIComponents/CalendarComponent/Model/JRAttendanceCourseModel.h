//
//  JRAttendanceCourseModel.h
//  ManagementPlatform
//
//  Created by 徐勇 on 2018/3/14.
//  Copyright © 2018年 ITUser. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 课程信息
 */
@interface JRAttendanceCourseModel : NSObject

@property (nonatomic, copy) NSString *classDate; // 上课日期
@property (nonatomic, copy) NSString *className; // 班级名称
@property (nonatomic, copy) NSString *classNo; //   班级编号
@property (nonatomic, copy) NSString *classRoom; // 班级房间(上课地点)
@property (nonatomic, assign) NSInteger lessonType; // 课次类型 1：常规课 2：写生课 3:补课周
@property (nonatomic, copy) NSString *classTime; // 上课时间段 ("17:00-18:30 ")
@property (nonatomic, copy) NSString *classId; //   教室ID
@property (nonatomic, assign) BOOL  mark; //是否标记
@property (nonatomic,strong) NSDate *date; //上课日期(精确到日)

//以下补课详情特有的字段
@property (nonatomic, copy) NSString *week; //   周日 周一...
@property (nonatomic, copy) NSString *teacherName; // 老师名称

//一下学生补课安排列表特有的字段
@property (nonatomic, assign) NSInteger status;//状态 1=请假 2=缺勤 3=未上课

//学生作品新增字段 课次
@property (nonatomic, strong) NSString *lessonIndex;

//以下自定义字段
@property (nonatomic, assign) NSInteger cellType; //显示该课程的样式(默认显示缺勤)[0: 缺勤,1:补课安排]
@property (nonatomic, assign) BOOL isSelect; // 是否选中


@property (nonatomic, copy) NSString *claTTSNo DEPRECATED_MSG_ATTRIBUTE("已经废弃"); // 课表序号
@property (nonatomic, copy) NSString *claListSNo DEPRECATED_MSG_ATTRIBUTE("已经废弃"); // 班级序号
@property (nonatomic, copy) NSString *claListID DEPRECATED_MSG_ATTRIBUTE("已经废弃"); // 班级代码
@property (nonatomic, copy) NSString *cListName DEPRECATED_MSG_ATTRIBUTE("已经废弃"); // 班级名称

@property (nonatomic, copy) NSString *timeFr DEPRECATED_MSG_ATTRIBUTE("已经废弃"); // 上课开始时间
@property (nonatomic, copy) NSString *timeTo DEPRECATED_MSG_ATTRIBUTE("已经废弃"); // 上课结束时间
@property (nonatomic, copy) NSString *doWeek DEPRECATED_MSG_ATTRIBUTE("已经废弃"); // 星期  0:星期日，1：星期一

@property (nonatomic, copy) NSString *cRoomID DEPRECATED_MSG_ATTRIBUTE("已经废弃"); // 教室ID
@property (nonatomic, copy) NSString *cRoomName DEPRECATED_MSG_ATTRIBUTE("已经废弃"); // 教室名称

@property (nonatomic, copy) NSString *empSno DEPRECATED_MSG_ATTRIBUTE("已经废弃"); // 老师序号
@property (nonatomic, copy) NSString *empId DEPRECATED_MSG_ATTRIBUTE("已经废弃"); // 老师ID
@property (nonatomic, copy) NSString *empName DEPRECATED_MSG_ATTRIBUTE("已经废弃"); // 老师名称

@property (nonatomic, assign) NSUInteger count DEPRECATED_MSG_ATTRIBUTE("已经废弃"); // 出勤异常数量


@end


