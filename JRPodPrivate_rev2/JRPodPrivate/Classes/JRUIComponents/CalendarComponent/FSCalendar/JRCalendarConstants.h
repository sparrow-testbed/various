//
//  JRCalendarConstane.h
//  JRCalendar
//
//  Created by dingwenchao on 8/28/15.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//
//  https://github.com/WenchaoD
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark - Constants

CG_EXTERN CGFloat const JRCalendarStandardHeaderHeight;
CG_EXTERN CGFloat const JRCalendarStandardWeekdayHeight;
CG_EXTERN CGFloat const JRCalendarStandardMonthlyPageHeight;
CG_EXTERN CGFloat const JRCalendarStandardWeeklyPageHeight;
CG_EXTERN CGFloat const JRCalendarStandardCellDiameter;
CG_EXTERN CGFloat const JRCalendarStandardSeparatorThickness;
CG_EXTERN CGFloat const JRCalendarAutomaticDimension;
CG_EXTERN CGFloat const JRCalendarDefaultBounceAnimationDuration;
CG_EXTERN CGFloat const JRCalendarStandardRowHeight;
CG_EXTERN CGFloat const JRCalendarStandardTitleTextSize;
CG_EXTERN CGFloat const JRCalendarStandardSubtitleTextSize;
CG_EXTERN CGFloat const JRCalendarStandardWeekdayTextSize;
CG_EXTERN CGFloat const JRCalendarStandardHeaderTextSize;
CG_EXTERN CGFloat const JRCalendarMaximumEventDotDiameter;
CG_EXTERN CGFloat const JRCalendarStandardScopeHandleHeight;

UIKIT_EXTERN NSInteger const JRCalendarDefaultHourComponent;

UIKIT_EXTERN NSString * const JRCalendarDefaultCellReuseIdentifier;
UIKIT_EXTERN NSString * const JRCalendarBlankCellReuseIdentifier;
UIKIT_EXTERN NSString * const JRCalendarInvalidArgumentsExceptionName;

CG_EXTERN CGPoint const CGPointInfinity;
CG_EXTERN CGSize const CGSizeAutomatic;

#if TARGET_INTERFACE_BUILDER
#define JRCalendarDeviceIsIPad NO
#else
#define JRCalendarDeviceIsIPad [[UIDevice currentDevice].model hasPrefix:@"iPad"]
#endif

#define JRCalendarStandardSelectionColor   FSColorRGBA(31,119,219,1.0)
#define JRCalendarStandardTodayColor       FSColorRGBA(198,51,42 ,1.0)
#define JRCalendarStandardTitleTextColor   FSColorRGBA(14,69,221 ,1.0)
#define JRCalendarStandardEventDotColor    FSColorRGBA(31,119,219,0.75)

#define JRCalendarStandardLineColor        [[UIColor lightGrayColor] colorWithAlphaComponent:0.30]
#define JRCalendarStandardSeparatorColor   [[UIColor lightGrayColor] colorWithAlphaComponent:0.60]
#define JRCalendarStandardScopeHandleColor [[UIColor lightGrayColor] colorWithAlphaComponent:0.50]

#define FSColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define XZYColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define JRCalendarInAppExtension [[[NSBundle mainBundle] bundlePath] hasSuffix:@".appex"]

#if CGFLOAT_IS_DOUBLE
#define JRCalendarFloor(c) floor(c)
#define JRCalendarRound(c) round(c)
#define JRCalendarCeil(c) ceil(c)
#define JRCalendarMod(c1,c2) fmod(c1,c2)
#else
#define JRCalendarFloor(c) floorf(c)
#define JRCalendarRound(c) roundf(c)
#define JRCalendarCeil(c) ceilf(c)
#define JRCalendarMod(c1,c2) fmodf(c1,c2)
#endif

#define JRCalendarUseWeakSelf __weak __typeof__(self) JRCalendarWeakSelf = self;
#define JRCalendarUseStrongSelf __strong __typeof__(self) self = JRCalendarWeakSelf;


#pragma mark - Deprecated

#define JRCalendarDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use " # instead " instead")

JRCalendarDeprecated('borderRadius')
typedef NS_ENUM(NSUInteger, JRCalendarCellShape) {
    JRCalendarCellShapeCircle    = 0,
    JRCalendarCellShapeRectangle = 1
};

typedef NS_ENUM(NSUInteger, JRCalendarUnit) {
    JRCalendarUnitMonth = NSCalendarUnitMonth,
    JRCalendarUnitWeekOfYear = NSCalendarUnitWeekOfYear,
    JRCalendarUnitDay = NSCalendarUnitDay
};

static inline void JRCalendarSliceCake(CGFloat cake, NSInteger count, CGFloat *pieces) {
    CGFloat total = cake;
    for (int i = 0; i < count; i++) {
        NSInteger remains = count - i;
        CGFloat piece = JRCalendarRound(total/remains*2)*0.5;
        total -= piece;
        pieces[i] = piece;
    }
}



