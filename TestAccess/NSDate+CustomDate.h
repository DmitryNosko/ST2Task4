//
//  NSDate+CustomDate.h
//  TestAccess
//
//  Created by USER on 7/5/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CustomDate)

+ (NSString*) strFromCurrentDate;
+ (NSRange) rangeFrom:(NSDate*) startDate endDate:(NSDate*) endDate;
+ (NSInteger) convertToMinutes:(NSDate*) date;
+ (NSString *)getDayNumber:(NSDate*) date;
+ (NSString *)getDayName:(NSDate*) date;
+ (NSDate*) getChoosenDate:(NSUInteger)weekNumber weekDay:(NSUInteger)weekDayNumber;

@end
