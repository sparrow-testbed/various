//
//  JRCalendarDynamicHeader.h
//  Pods
//
//  Created by DingWenchao on 6/29/15.
//
//  动感头文件，仅供框架内部使用。
//  Private header, don't use it.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "JRCalendar.h"
#import "JRCalendarCell.h"
#import "JRCalendarHeaderView.h"
#import "JRCalendarStickyHeader.h"
#import "JRCalendarCollectionView.h"
#import "JRCalendarCollectionViewLayout.h"
#import "JRCalendarScopeHandle.h"
#import "JRCalendarCalculator.h"
#import "JRCalendarTransitionCoordinator.h"
#import "JRCalendarDelegationProxy.h"

@interface JRCalendar (Dynamic)

@property (readonly, nonatomic) JRCalendarCollectionView *collectionView;
@property (readonly, nonatomic) JRCalendarScopeHandle *scopeHandle;
@property (readonly, nonatomic) JRCalendarCollectionViewLayout *collectionViewLayout;
@property (readonly, nonatomic) JRCalendarTransitionCoordinator *transitionCoordinator;
@property (readonly, nonatomic) JRCalendarCalculator *calculator;
@property (readonly, nonatomic) BOOL floatingMode;
@property (readonly, nonatomic) NSArray *visibleStickyHeaders;
@property (readonly, nonatomic) CGFloat preferredHeaderHeight;
@property (readonly, nonatomic) CGFloat preferredWeekdayHeight;
@property (readonly, nonatomic) UIView *bottomBorder;

@property (readonly, nonatomic) NSCalendar *gregorian;
@property (readonly, nonatomic) NSDateComponents *components;
@property (readonly, nonatomic) NSDateFormatter *formatter;

@property (readonly, nonatomic) UIView *contentView;
@property (readonly, nonatomic) UIView *daysContainer;

@property (assign, nonatomic) BOOL needsAdjustingViewFrame;

- (void)invalidateHeaders;
- (void)adjustMonthPosition;

- (BOOL)isPageInRange:(NSDate *)page;
- (BOOL)isDateInRange:(NSDate *)date;

- (CGSize)sizeThatFits:(CGSize)size scope:(JRCalendarScope)scope;

@end

@interface JRCalendarAppearance (Dynamic)

@property (readwrite, nonatomic) JRCalendar *calendar;

@property (readonly, nonatomic) NSDictionary *backgroundColors;
@property (readonly, nonatomic) NSDictionary *titleColors;
@property (readonly, nonatomic) NSDictionary *subtitleColors;
@property (readonly, nonatomic) NSDictionary *borderColors;

@end

@interface JRCalendarWeekdayView (Dynamic)

@property (readwrite, nonatomic) JRCalendar *calendar;

@end

@interface JRCalendarCollectionViewLayout (Dynamic)

@property (readonly, nonatomic) CGSize estimatedItemSize;

@end

@interface JRCalendarDelegationProxy()<JRCalendarDataSource,JRCalendarDelegate,JRCalendarDelegateAppearance>
@end


