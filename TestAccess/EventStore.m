//
//  EventStore.m
//  TestAccess
//
//  Created by USER on 7/3/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "EventStore.h"

static EKEventStore* eventStore;

@implementation EventStore

+ (EKEventStore *)getInstance {
    if (eventStore == nil) {
        eventStore = [[EKEventStore alloc] init];
    }
    return eventStore;
}

@end
