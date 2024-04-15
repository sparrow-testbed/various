//
//  JRCalendarDelegationFactory.m
//  JRCalendar
//
//  Created by dingwenchao on 19/12/2016.
//  Copyright © 2016 wenchaoios. All rights reserved.
//

#import "JRCalendarDelegationFactory.h"

#define JRCalendarSelectorEntry(SEL1,SEL2) NSStringFromSelector(@selector(SEL1)):NSStringFromSelector(@selector(SEL2))

@implementation JRCalendarDelegationFactory

+ (JRCalendarDelegationProxy *)dataSourceProxy
{
    JRCalendarDelegationProxy *delegation = [[JRCalendarDelegationProxy alloc] init];
    delegation.protocol = @protocol(JRCalendarDataSource);
    delegation.deprecations = @{JRCalendarSelectorEntry(calendar:numberOfEventsForDate:, calendar:hasEventForDate:)};
    return delegation;
}

+ (JRCalendarDelegationProxy *)delegateProxy
{
    JRCalendarDelegationProxy *delegation = [[JRCalendarDelegationProxy alloc] init];
    delegation.protocol = @protocol(JRCalendarDelegateAppearance);
    delegation.deprecations = @{
                                JRCalendarSelectorEntry(calendarCurrentPageDidChange:, calendarCurrentMonthDidChange:),
                                JRCalendarSelectorEntry(calendar:shouldSelectDate:atMonthPosition:, calendar:shouldSelectDate:),
                                JRCalendarSelectorEntry(calendar:didSelectDate:atMonthPosition:, calendar:didSelectDate:),
                                JRCalendarSelectorEntry(calendar:shouldDeselectDate:atMonthPosition:, calendar:shouldDeselectDate:),
                                JRCalendarSelectorEntry(calendar:didDeselectDate:atMonthPosition:, calendar:didDeselectDate:)
                               };
    return delegation;
}

@end

#undef JRCalendarSelectorEntry

