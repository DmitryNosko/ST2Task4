//
//  EventStore.h
//  TestAccess
//
//  Created by USER on 7/3/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventStore : NSObject
+ (EKEventStore*) getInstance;
@end
