//
//  JRCalendarTransitionCoordinator.h
//  JRCalendar
//
//  Created by dingwenchao on 3/13/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "JRCalendar.h"
#import "JRCalendarCollectionView.h"
#import "JRCalendarCollectionViewLayout.h"
#import "JRCalendarScopeHandle.h"

typedef NS_ENUM(NSUInteger, JRCalendarTransition) {
    JRCalendarTransitionNone,
    JRCalendarTransitionMonthToWeek,
    JRCalendarTransitionWeekToMonth
};
typedef NS_ENUM(NSUInteger, JRCalendarTransitionState) {
    JRCalendarTransitionStateIdle,
    JRCalendarTransitionStateChanging,
    JRCalendarTransitionStateFinishing,
};

@interface JRCalendarTransitionCoordinator : NSObject <UIGestureRecognizerDelegate>

@property (weak, nonatomic) JRCalendar *calendar;
@property (weak, nonatomic) JRCalendarCollectionView *collectionView;
@property (weak, nonatomic) JRCalendarCollectionViewLayout *collectionViewLayout;

@property (assign, nonatomic) JRCalendarTransition transition;
@property (assign, nonatomic) JRCalendarTransitionState state;

@property (assign, nonatomic) CGSize cachedMonthSize;

@property (readonly, nonatomic) JRCalendarScope representingScope;

- (instancetype)initWithCalendar:(JRCalendar *)calendar;

- (void)performScopeTransitionFromScope:(JRCalendarScope)fromScope toScope:(JRCalendarScope)toScope animated:(BOOL)animated;
- (void)performBoundingRectTransitionFromMonth:(NSDate *)fromMonth toMonth:(NSDate *)toMonth duration:(CGFloat)duration;

- (void)handleScopeGesture:(id)sender;

@end


@interface JRCalendarTransitionAttributes : NSObject

@property (assign, nonatomic) CGRect sourceBounds;
@property (assign, nonatomic) CGRect targetBounds;
@property (strong, nonatomic) NSDate *sourcePage;
@property (strong, nonatomic) NSDate *targetPage;
@property (assign, nonatomic) NSInteger focusedRowNumber;
@property (assign, nonatomic) NSDate *focusedDate;
@property (strong, nonatomic) NSDate *firstDayOfMonth;

@end

