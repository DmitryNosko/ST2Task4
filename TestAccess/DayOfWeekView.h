//
//  DayOfWeekView.h
//  TestAccess
//
//  Created by USER on 6/30/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayOfWeekView : UIView
@property (assign, nonatomic) NSInteger numberOfDay;
@property (strong, nonatomic) NSString* dayName;
@property (assign, nonatomic) BOOL hasEvent;
- (instancetype)initWith:(NSString*) dayName numberOfDay:(NSInteger) numberOfDay hasEvent:(BOOL) hasEvent;
@end
