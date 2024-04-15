//
//  JRCalendarDelegationFactory.h
//  JRCalendar
//
//  Created by dingwenchao on 19/12/2016.
//  Copyright © 2016 wenchaoios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRCalendarDelegationProxy.h"

@interface JRCalendarDelegationFactory : NSObject

+ (JRCalendarDelegationProxy *)dataSourceProxy;
+ (JRCalendarDelegationProxy *)delegateProxy;

@end
