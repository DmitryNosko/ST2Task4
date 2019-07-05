//
//  EventRepository.m
//  TestAccess
//
//  Created by USER on 7/5/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "EventRepository.h"
#import "NSCalendar+CustomCalendar.h"

@interface EventRepository ()
@property (strong, nonatomic) EKEventStore* eventStore;
@property (strong, nonatomic) EKCalendar* calendar;
@end

@implementation EventRepository
- (instancetype)initWithEventStore:(EKEventStore*) eventStore
{
    self = [super init];
    if (self) {
        self.eventStore = eventStore;
    }
    return self;
}

- (BOOL) hasEventsAtDate:(NSDate*) date {
    return [self getEventsForDate:date].count > 0;
}

- (NSArray<EKEvent*>*) getEventsForDate:(NSDate*) date {
    NSDate *startDate = [[NSCalendar gregorianCalendar] dateBySettingHour:0  minute:0  second:0  ofDate:date options:0];
    NSDate *endDate   = [[NSCalendar gregorianCalendar] dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];

    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                      endDate:endDate
                                                                    calendars:nil];

    return [self.eventStore eventsMatchingPredicate:predicate];
}

@end
