//
//  NSDate+CustomDate.m
//  TestAccess
//
//  Created by USER on 7/5/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "NSDate+CustomDate.h"
#import "NSDateFormatter+CustomDateFormatter.h"
#import "NSCalendar+CustomCalendar.h"

static NSInteger const MINUTES_IN_HOUR = 60;

@implementation NSDate (CustomDate)

+ (NSString*) strFromCurrentDate {
    NSDate *currentDate = [NSDate date];
    return [[NSDateFormatter hourminutesDateFormatter] stringFromDate:currentDate];
}

+ (NSRange) rangeFrom:(NSDate*) startDate endDate:(NSDate*) endDate {
    NSDateComponents *startDateComponents = [[NSCalendar gregorianCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate];
    NSInteger startHour = [startDateComponents hour];
    NSInteger startMinute = [startDateComponents minute];
    
    NSDateComponents *endDateComponents = [[NSCalendar gregorianCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:endDate];
    NSInteger endHour = [endDateComponents hour];
    NSInteger endMinute = [endDateComponents minute];
    
    NSUInteger loc = startHour * MINUTES_IN_HOUR + startMinute;
    NSUInteger len = endHour * MINUTES_IN_HOUR + endMinute - loc;
    
    return NSMakeRange(loc, len);
}

+ (NSInteger) convertToMinutes:(NSDate*) date {
    NSDate *todaydate = [[NSDateFormatter hourminutesDateFormatter] dateFromString:[[NSDateFormatter hourminutesDateFormatter]  stringFromDate:[NSDate date]]];
    NSDateComponents *startDateComponents = [[NSCalendar gregorianCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:todaydate];
    NSInteger startHour = [startDateComponents hour];
    NSInteger startMinute = [startDateComponents minute];
    return startHour * MINUTES_IN_HOUR + startMinute;
}

+ (NSString *)getDayNumber:(NSDate*) date {
    return [[NSDateFormatter weekDayNunmberFormatter] stringFromDate:date];
}

+ (NSString *)getDayName:(NSDate*) date {
    return [[NSDateFormatter weekDayNameFormatter] stringFromDate:date];
}

+ (NSDate*) getChoosenDate:(NSUInteger)weekNumber weekDay:(NSUInteger)weekDayNumber {
    NSDateComponents *components = [[NSCalendar gregorianCalendar] components:NSCalendarUnitYearForWeekOfYear|NSCalendarUnitYear|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:[NSDate date]];
    weekDayNumber = weekDayNumber + 1 == 7 ? 0 : weekDayNumber + 1;
    NSUInteger currentWeekOfYear = components.weekOfYear;
    [components setWeekOfYear:currentWeekOfYear + weekNumber];
    [components setWeekday:weekDayNumber + 1];
    return [[NSCalendar gregorianCalendar] dateFromComponents:components];
}

@end


























