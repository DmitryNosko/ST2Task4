//
//  DayOfWeekView.m
//  TestAccess
//
//  Created by USER on 6/30/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "DayOfWeekView.h"

@implementation DayOfWeekView

- (instancetype)initWith:(NSString*) dayName numberOfDay:(NSInteger) numberOfDay hasEvent:(BOOL) hasEvent
{
    self = [super init];
    if (self) {
        _dayName = dayName;
        _numberOfDay = numberOfDay;
        _hasEvent = hasEvent;
    }
    return self;
}

@end