//
//  JRCalendarConstane.m
//  JRCalendar
//
//  Created by dingwenchao on 8/28/15.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//
//  https://github.com/WenchaoD
//

#import "JRCalendarConstants.h"

CGFloat const JRCalendarStandardHeaderHeight = 40;
CGFloat const JRCalendarStandardWeekdayHeight = 25;
CGFloat const JRCalendarStandardMonthlyPageHeight = 300.0;
CGFloat const JRCalendarStandardWeeklyPageHeight = 108+1/3.0;
CGFloat const JRCalendarStandardCellDiameter = 100/3.0;
CGFloat const JRCalendarStandardSeparatorThickness = 0.5;
CGFloat const JRCalendarAutomaticDimension = -1;
CGFloat const JRCalendarDefaultBounceAnimationDuration = 0.15;
CGFloat const JRCalendarStandardRowHeight = 38;
CGFloat const JRCalendarStandardTitleTextSize = 13.5;
CGFloat const JRCalendarStandardSubtitleTextSize = 10;
CGFloat const JRCalendarStandardWeekdayTextSize = 14;
CGFloat const JRCalendarStandardHeaderTextSize = 16.5;
CGFloat const JRCalendarMaximumEventDotDiameter = 4.8;
CGFloat const JRCalendarStandardScopeHandleHeight = 26;

NSInteger const JRCalendarDefaultHourComponent = 0;

NSString * const JRCalendarDefaultCellReuseIdentifier = @"_JRCalendarDefaultCellReuseIdentifier";
NSString * const JRCalendarBlankCellReuseIdentifier = @"_JRCalendarBlankCellReuseIdentifier";
NSString * const JRCalendarInvalidArgumentsExceptionName = @"Invalid argument exception";

CGPoint const CGPointInfinity = {
    .x =  CGFLOAT_MAX,
    .y =  CGFLOAT_MAX
};

CGSize const CGSizeAutomatic = {
    .width =  JRCalendarAutomaticDimension,
    .height =  JRCalendarAutomaticDimension
};



