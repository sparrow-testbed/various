//
//  JRCalendarStaticHeader.h
//  JRCalendar
//
//  Created by dingwenchao on 9/17/15.
//  Copyright (c) 2015 Wenchao Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRCalendar,JRCalendarAppearance;

@interface JRCalendarStickyHeader : UICollectionReusableView

@property (weak, nonatomic) JRCalendar *calendar;

@property (weak, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSDate *month;

- (void)reloadData;
- (void)configureAppearance;

@end
