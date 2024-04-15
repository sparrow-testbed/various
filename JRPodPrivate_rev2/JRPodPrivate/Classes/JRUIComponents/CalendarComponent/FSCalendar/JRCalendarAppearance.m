//
//  JRCalendarAppearance.m
//  Pods
//
//  Created by DingWenchao on 6/29/15.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//
//  https://github.com/WenchaoD
//

#import "JRCalendarAppearance.h"
#import "JRCalendarDynamicHeader.h"
#import "JRCalendarExtensions.h"



@interface JRCalendarAppearance ()

@property (weak  , nonatomic) JRCalendar *calendar;

@property (strong, nonatomic) NSMutableDictionary *backgroundColors;
@property (strong, nonatomic) NSMutableDictionary *titleColors;
@property (strong, nonatomic) NSMutableDictionary *subtitleColors;
@property (strong, nonatomic) NSMutableDictionary *borderColors;

@end

@implementation JRCalendarAppearance

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _titleFont = [UIFont systemFontOfSize:JRCalendarStandardTitleTextSize];
        _subtitleFont = [UIFont systemFontOfSize:JRCalendarStandardSubtitleTextSize];
        _weekdayFont = [UIFont systemFontOfSize:JRCalendarStandardWeekdayTextSize];
        _headerTitleFont = [UIFont systemFontOfSize:JRCalendarStandardHeaderTextSize];
        
        _headerTitleColor = JRCalendarStandardTitleTextColor;
        _headerDateFormat = @"MMMM yyyy";
        _headerMinimumDissolvedAlpha = 0.2;
        _weekdayTextColor = JRCalendarStandardTitleTextColor;
        _caseOptions = JRCalendarCaseOptionsHeaderUsesDefaultCase|JRCalendarCaseOptionsWeekdayUsesDefaultCase;
        
        _backgroundColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _backgroundColors[@(JRCalendarCellStateNormal)]      = [UIColor clearColor];
        _backgroundColors[@(JRCalendarCellStateSelected)]    = JRCalendarStandardSelectionColor;
        _backgroundColors[@(JRCalendarCellStateDisabled)]    = [UIColor clearColor];
        _backgroundColors[@(JRCalendarCellStatePlaceholder)] = [UIColor clearColor];
        _backgroundColors[@(JRCalendarCellStateToday)]       = JRCalendarStandardTodayColor;
        
        _titleColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _titleColors[@(JRCalendarCellStateNormal)]      = [UIColor blackColor];
        _titleColors[@(JRCalendarCellStateSelected)]    = [UIColor whiteColor];
        _titleColors[@(JRCalendarCellStateDisabled)]    = [UIColor grayColor];
        _titleColors[@(JRCalendarCellStatePlaceholder)] = [UIColor lightGrayColor];
        _titleColors[@(JRCalendarCellStateToday)]       = [UIColor whiteColor];
        
        _subtitleColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _subtitleColors[@(JRCalendarCellStateNormal)]      = [UIColor darkGrayColor];
        _subtitleColors[@(JRCalendarCellStateSelected)]    = [UIColor whiteColor];
        _subtitleColors[@(JRCalendarCellStateDisabled)]    = [UIColor lightGrayColor];
        _subtitleColors[@(JRCalendarCellStatePlaceholder)] = [UIColor lightGrayColor];
        _subtitleColors[@(JRCalendarCellStateToday)]       = [UIColor whiteColor];
        
        _borderColors[@(JRCalendarCellStateSelected)] = [UIColor clearColor];
        _borderColors[@(JRCalendarCellStateNormal)] = [UIColor clearColor];
        
        _borderRadius = 1.0;
        _eventDefaultColor = JRCalendarStandardEventDotColor;
        _eventSelectionColor = JRCalendarStandardEventDotColor;
        
        _borderColors = [NSMutableDictionary dictionaryWithCapacity:2];
        
#if TARGET_INTERFACE_BUILDER
        _fakeEventDots = YES;
#endif
        
    }
    return self;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (![_titleFont isEqual:titleFont]) {
        _titleFont = titleFont;
        self.calendar.calculator.titleHeight = -1;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setSubtitleFont:(UIFont *)subtitleFont
{
    if (![_subtitleFont isEqual:subtitleFont]) {
        _subtitleFont = subtitleFont;
        self.calendar.calculator.subtitleHeight = -1;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setWeekdayFont:(UIFont *)weekdayFont
{
    if (![_weekdayFont isEqual:weekdayFont]) {
        _weekdayFont = weekdayFont;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setHeaderTitleFont:(UIFont *)headerTitleFont
{
    if (![_headerTitleFont isEqual:headerTitleFont]) {
        _headerTitleFont = headerTitleFont;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setTitleOffset:(CGPoint)titleOffset
{
    if (!CGPointEqualToPoint(_titleOffset, titleOffset)) {
        _titleOffset = titleOffset;
        [_calendar.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setSubtitleOffset:(CGPoint)subtitleOffset
{
    if (!CGPointEqualToPoint(_subtitleOffset, subtitleOffset)) {
        _subtitleOffset = subtitleOffset;
        [_calendar.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    if (!CGPointEqualToPoint(_imageOffset, imageOffset)) {
        _imageOffset = imageOffset;
        [_calendar.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setEventOffset:(CGPoint)eventOffset
{
    if (!CGPointEqualToPoint(_eventOffset, eventOffset)) {
        _eventOffset = eventOffset;
        [_calendar.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setTitleDefaultColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(JRCalendarCellStateNormal)] = color;
    } else {
        [_titleColors removeObjectForKey:@(JRCalendarCellStateNormal)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)titleDefaultColor
{
    return _titleColors[@(JRCalendarCellStateNormal)];
}

- (void)setTitleSelectionColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(JRCalendarCellStateSelected)] = color;
    } else {
        [_titleColors removeObjectForKey:@(JRCalendarCellStateSelected)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)titleSelectionColor
{
    return _titleColors[@(JRCalendarCellStateSelected)];
}

- (void)setTitleTodayColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(JRCalendarCellStateToday)] = color;
    } else {
        [_titleColors removeObjectForKey:@(JRCalendarCellStateToday)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)titleTodayColor
{
    return _titleColors[@(JRCalendarCellStateToday)];
}

- (void)setTitlePlaceholderColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(JRCalendarCellStatePlaceholder)] = color;
    } else {
        [_titleColors removeObjectForKey:@(JRCalendarCellStatePlaceholder)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)titlePlaceholderColor
{
    return _titleColors[@(JRCalendarCellStatePlaceholder)];
}

- (void)setTitleWeekendColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(JRCalendarCellStateWeekend)] = color;
    } else {
        [_titleColors removeObjectForKey:@(JRCalendarCellStateWeekend)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)titleWeekendColor
{
    return _titleColors[@(JRCalendarCellStateWeekend)];
}

- (void)setSubtitleDefaultColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(JRCalendarCellStateNormal)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(JRCalendarCellStateNormal)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)subtitleDefaultColor
{
    return _subtitleColors[@(JRCalendarCellStateNormal)];
}

- (void)setSubtitleSelectionColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(JRCalendarCellStateSelected)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(JRCalendarCellStateSelected)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)subtitleSelectionColor
{
    return _subtitleColors[@(JRCalendarCellStateSelected)];
}

- (void)setSubtitleTodayColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(JRCalendarCellStateToday)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(JRCalendarCellStateToday)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)subtitleTodayColor
{
    return _subtitleColors[@(JRCalendarCellStateToday)];
}

- (void)setSubtitlePlaceholderColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(JRCalendarCellStatePlaceholder)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(JRCalendarCellStatePlaceholder)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)subtitlePlaceholderColor
{
    return _subtitleColors[@(JRCalendarCellStatePlaceholder)];
}

- (void)setSubtitleWeekendColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(JRCalendarCellStateWeekend)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(JRCalendarCellStateWeekend)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)subtitleWeekendColor
{
    return _subtitleColors[@(JRCalendarCellStateWeekend)];
}

- (void)setSelectionColor:(UIColor *)color
{
    if (color) {
        _backgroundColors[@(JRCalendarCellStateSelected)] = color;
    } else {
        [_backgroundColors removeObjectForKey:@(JRCalendarCellStateSelected)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)selectionColor
{
    return _backgroundColors[@(JRCalendarCellStateSelected)];
}

- (void)setTodayColor:(UIColor *)todayColor
{
    if (todayColor) {
        _backgroundColors[@(JRCalendarCellStateToday)] = todayColor;
    } else {
        [_backgroundColors removeObjectForKey:@(JRCalendarCellStateToday)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)todayColor
{
    return _backgroundColors[@(JRCalendarCellStateToday)];
}

- (void)setTodaySelectionColor:(UIColor *)todaySelectionColor
{
    if (todaySelectionColor) {
        _backgroundColors[@(JRCalendarCellStateToday|JRCalendarCellStateSelected)] = todaySelectionColor;
    } else {
        [_backgroundColors removeObjectForKey:@(JRCalendarCellStateToday|JRCalendarCellStateSelected)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)todaySelectionColor
{
    return _backgroundColors[@(JRCalendarCellStateToday|JRCalendarCellStateSelected)];
}

- (void)setEventDefaultColor:(UIColor *)eventDefaultColor
{
//    if (![_eventDefaultColor isEqual:eventDefaultColor]) {
        _eventDefaultColor = eventDefaultColor;
        [self.calendar setNeedsConfigureAppearance];
//    }
}

- (void)setBorderDefaultColor:(UIColor *)color
{
    if (color) {
        _borderColors[@(JRCalendarCellStateNormal)] = color;
    } else {
        [_borderColors removeObjectForKey:@(JRCalendarCellStateNormal)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)borderDefaultColor
{
    return _borderColors[@(JRCalendarCellStateNormal)];
}

- (void)setBorderSelectionColor:(UIColor *)color
{
    if (color) {
        _borderColors[@(JRCalendarCellStateSelected)] = color;
    } else {
        [_borderColors removeObjectForKey:@(JRCalendarCellStateSelected)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)borderSelectionColor
{
    return _borderColors[@(JRCalendarCellStateSelected)];
}

- (void)setBorderRadius:(CGFloat)borderRadius
{
    borderRadius = MAX(0.0, borderRadius);
    borderRadius = MIN(1.0, borderRadius);
    if (_borderRadius != borderRadius) {
        _borderRadius = borderRadius;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setWeekdayTextColor:(UIColor *)weekdayTextColor
{
    if (![_weekdayTextColor isEqual:weekdayTextColor]) {
        _weekdayTextColor = weekdayTextColor;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setHeaderTitleColor:(UIColor *)color
{
    if (![_headerTitleColor isEqual:color]) {
        _headerTitleColor = color;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setHeaderMinimumDissolvedAlpha:(CGFloat)headerMinimumDissolvedAlpha
{
    if (_headerMinimumDissolvedAlpha != headerMinimumDissolvedAlpha) {
        _headerMinimumDissolvedAlpha = headerMinimumDissolvedAlpha;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setHeaderDateFormat:(NSString *)headerDateFormat
{
    if (![_headerDateFormat isEqual:headerDateFormat]) {
        _headerDateFormat = headerDateFormat;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setCaseOptions:(JRCalendarCaseOptions)caseOptions
{
    if (_caseOptions != caseOptions) {
        _caseOptions = caseOptions;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setSeparators:(JRCalendarSeparators)separators
{
    if (_separators != separators) {
        _separators = separators;
        [_calendar.collectionView.collectionViewLayout invalidateLayout];
    }
}

@end


@implementation JRCalendarAppearance (Deprecated)

- (void)setUseVeryShortWeekdaySymbols:(BOOL)useVeryShortWeekdaySymbols
{
    _caseOptions &= 15;
    self.caseOptions |= (useVeryShortWeekdaySymbols*JRCalendarCaseOptionsWeekdayUsesSingleUpperCase);
}

- (BOOL)useVeryShortWeekdaySymbols
{
    return (_caseOptions & (15<<4) ) == JRCalendarCaseOptionsWeekdayUsesSingleUpperCase;
}

- (void)setTitleVerticalOffset:(CGFloat)titleVerticalOffset
{
    self.titleOffset = CGPointMake(0, titleVerticalOffset);
}

- (CGFloat)titleVerticalOffset
{
    return self.titleOffset.y;
}

- (void)setSubtitleVerticalOffset:(CGFloat)subtitleVerticalOffset
{
    self.subtitleOffset = CGPointMake(0, subtitleVerticalOffset);
}

- (CGFloat)subtitleVerticalOffset
{
    return self.subtitleOffset.y;
}

- (void)setEventColor:(UIColor *)eventColor
{
    self.eventDefaultColor = eventColor;
}

- (UIColor *)eventColor
{
    return self.eventDefaultColor;
}

- (void)setCellShape:(JRCalendarCellShape)cellShape
{
    self.borderRadius = 1-cellShape;
}

- (JRCalendarCellShape)cellShape
{
    return self.borderRadius==1.0?JRCalendarCellShapeCircle:JRCalendarCellShapeRectangle;
}

- (void)setTitleTextSize:(CGFloat)titleTextSize
{
    self.titleFont = [UIFont fontWithName:self.titleFont.fontName size:titleTextSize];
}

- (void)setSubtitleTextSize:(CGFloat)subtitleTextSize
{
    self.subtitleFont = [UIFont fontWithName:self.subtitleFont.fontName size:subtitleTextSize];
}

- (void)setWeekdayTextSize:(CGFloat)weekdayTextSize
{
    self.weekdayFont = [UIFont fontWithName:self.weekdayFont.fontName size:weekdayTextSize];
}

- (void)setHeaderTitleTextSize:(CGFloat)headerTitleTextSize
{
    self.headerTitleFont = [UIFont fontWithName:self.headerTitleFont.fontName size:headerTitleTextSize];
}

- (void)invalidateAppearance
{
    [self.calendar setNeedsConfigureAppearance];
}

- (void)setAdjustsFontSizeToFitContentSize:(BOOL)adjustsFontSizeToFitContentSize {}
- (BOOL)adjustsFontSizeToFitContentSize { return YES; }

@end


