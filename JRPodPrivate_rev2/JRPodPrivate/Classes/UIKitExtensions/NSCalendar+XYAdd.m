//
//  NSCalendar+XYAdd.m
//  ArtLibrary
//
//  Created by 徐勇 on 2017/1/16.
//  Copyright © 2017年 徐勇. All rights reserved.
//

#import "NSCalendar+XYAdd.h"

@implementation NSCalendar (XYAdd)

+ (instancetype)calendar {
    if ([NSCalendar instancesRespondToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    } else {
        return [NSCalendar currentCalendar];
    }
}

@end
