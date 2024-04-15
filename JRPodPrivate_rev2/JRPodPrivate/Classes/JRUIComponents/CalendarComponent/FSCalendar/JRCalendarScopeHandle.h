//
//  JRCalendarScopeHandle.h
//  JRCalendar
//
//  Created by dingwenchao on 4/29/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRCalendar;

@interface JRCalendarScopeHandle : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIPanGestureRecognizer *panGesture;
@property (weak, nonatomic) JRCalendar *calendar;

- (void)handlePan:(id)sender;

@end
