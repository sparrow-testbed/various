//
//  JRCalendarHeader.h
//  Pods
//
//  Created by Wenchao Ding on 29/1/15.
//
//

#import <UIKit/UIKit.h>


@class JRCalendar, JRCalendarAppearance, JRCalendarHeaderLayout, JRCalendarCollectionView;

@interface JRCalendarHeaderView : UIView

@property (weak, nonatomic) JRCalendarCollectionView *collectionView;
@property (weak, nonatomic) JRCalendarHeaderLayout *collectionViewLayout;
@property (weak, nonatomic) JRCalendar *calendar;

@property (assign, nonatomic) CGFloat scrollOffset;
@property (assign, nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (assign, nonatomic) BOOL scrollEnabled;
@property (assign, nonatomic) BOOL needsAdjustingViewFrame;
@property (assign, nonatomic) BOOL needsAdjustingMonthPosition;

- (void)setScrollOffset:(CGFloat)scrollOffset animated:(BOOL)animated;
- (void)reloadData;
- (void)configureAppearance;

@end


@interface JRCalendarHeaderCell : UICollectionViewCell

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) JRCalendarHeaderView *header;

@end

@interface JRCalendarHeaderLayout : UICollectionViewFlowLayout

@end

@interface JRCalendarHeaderTouchDeliver : UIView

@property (weak, nonatomic) JRCalendar *calendar;
@property (weak, nonatomic) JRCalendarHeaderView *header;

@end
