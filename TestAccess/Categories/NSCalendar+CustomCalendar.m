//
//  NSCalendar+CustomCalendar.m
//  TestAccess
//
//  Created by USER on 7/5/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "NSCalendar+CustomCalendar.h"

@implementation NSCalendar (CustomCalendar)

+ (NSCalendar*) gregorianCalendar {
    NSCalendar* calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    [calendar setFirstWeekday:2];
    return calendar;
}

@end
