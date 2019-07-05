//
//  NSDate+CustomDate.m
//  TestAccess
//
//  Created by USER on 7/4/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "NSDate+CustomDate.h"

@interface NSDate ()
@property (strong, nonatomic) NSCalendar* calendar;
@property (strong, nonatomic) NSDateFormatter *weekDayNumberformatter;
@property (strong, nonatomic) NSDateFormatter *weekDayNameformatter;
@end

@implementation NSDate (CustomDate)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        [self.calendar setTimeZone:[NSTimeZone localTimeZone]];
        [self.calendar setFirstWeekday:2];
        
        NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"ru"];
        
        self.weekDayNumberformatter = [[NSDateFormatter alloc] init];
        [self.weekDayNumberformatter setLocale:locale];
        [self.weekDayNumberformatter setDateFormat:@"dd"];
        
        self.weekDayNameformatter = [[NSDateFormatter alloc] init];
        [self.weekDayNameformatter setLocale:locale];
        [self.weekDayNameformatter setDateFormat:@"EE"];
    }
    return self;
}

+ (NSString *)getDayNumber:(NSDate*) date {
    return [self.weekDayNumberformatter stringFromDate:date];
}

+ (NSString *)getDayName:(NSDate*) date {
    return [self.weekDayNameformatter stringFromDate:date];
}

+ (NSDate*) getChoosenDate:(NSUInteger)weekNumber weekDay:(NSUInteger)weekDayNumber {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYearForWeekOfYear|NSCalendarUnitYear|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:[NSDate date]];
    weekDayNumber = weekDayNumber + 1 == 7 ? 0 : weekDayNumber + 1;
    NSUInteger currentWeekOfYear = components.weekOfYear;
    [components setWeekOfYear:currentWeekOfYear + weekNumber];
    [components setWeekday:weekDayNumber + 1];
    return [self.calendar dateFromComponents:components];
}

//+ (BOOL) hasEventsAtDate:(NSDate*) date {
//
//    NSDate *startDate = [self.calendar dateBySettingHour:0  minute:0  second:0  ofDate:date options:0];
//    NSDate *endDate   = [self.calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];
//
//    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
//                                                                      endDate:endDate
//                                                                    calendars:nil];
//
//    NSArray<EKEvent*>* events = [self.eventStore eventsMatchingPredicate:predicate];
//
//    return events.count > 0;
//}

@end
