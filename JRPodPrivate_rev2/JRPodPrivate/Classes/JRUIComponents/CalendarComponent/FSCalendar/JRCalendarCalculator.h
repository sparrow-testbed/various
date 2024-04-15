//
//  JRCalendarCalculator.h
//  JRCalendar
//
//  Created by dingwenchao on 30/10/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class JRCalendar;

typedef NS_ENUM(NSUInteger, JRCalendarMonthPosition);

struct JRCalendarCoordinate {
    NSInteger row;
    NSInteger column;
};
typedef struct JRCalendarCoordinate JRCalendarCoordinate;

@interface JRCalendarCalculator : NSObject

@property (weak  , nonatomic) JRCalendar *calendar;

@property (assign, nonatomic) CGFloat titleHeight;
@property (assign, nonatomic) CGFloat subtitleHeight;

@property (readonly, nonatomic) NSInteger numberOfSections;

- (instancetype)initWithCalendar:(JRCalendar *)calendar;

- (NSDate *)safeDateForDate:(NSDate *)date;

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath scope:(JRCalendarScope)scope;
- (NSIndexPath *)indexPathForDate:(NSDate *)date;
- (NSIndexPath *)indexPathForDate:(NSDate *)date scope:(JRCalendarScope)scope;
- (NSIndexPath *)indexPathForDate:(NSDate *)date atMonthPosition:(JRCalendarMonthPosition)position;
- (NSIndexPath *)indexPathForDate:(NSDate *)date atMonthPosition:(JRCalendarMonthPosition)position scope:(JRCalendarScope)scope;

- (NSDate *)pageForSection:(NSInteger)section;
- (NSDate *)weekForSection:(NSInteger)section;
- (NSDate *)monthForSection:(NSInteger)section;
- (NSDate *)monthHeadForSection:(NSInteger)section;

- (NSInteger)numberOfHeadPlaceholdersForMonth:(NSDate *)month;
- (NSInteger)numberOfRowsInMonth:(NSDate *)month;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (JRCalendarMonthPosition)monthPositionForIndexPath:(NSIndexPath *)indexPath;
- (JRCalendarCoordinate)coordinateForIndexPath:(NSIndexPath *)indexPath;

- (void)reloadSections;

@end
