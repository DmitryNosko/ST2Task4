//
//  EventRepository.h
//  TestAccess
//
//  Created by USER on 7/5/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventRepository : NSObject
- (instancetype)initWithEventStore:(EKEventStore*) eventStore;
- (BOOL) hasEventsAtDate:(NSDate*) date;
- (NSArray<EKEvent*>*) getEventsForDate:(NSDate*) date;

@end
