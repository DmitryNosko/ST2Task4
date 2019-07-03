//
//  Event.m
//  TestAccess
//
//  Created by USER on 7/1/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "Event.h"

@implementation Event

+ (Event *)eventWithTitle:(NSString *)title timespan:(NSRange)timespan color:(UIColor *)color {
    Event* event = [Event new];
    event.title = title;
    event.timespan = timespan;
    event.color = color;
    return event;
}

@end
