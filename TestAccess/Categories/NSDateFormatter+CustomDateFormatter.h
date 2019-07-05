//
//  NSDateFormatter+CustomDateFormatter.h
//  TestAccess
//
//  Created by USER on 7/5/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (CustomDateFormatter)
+ (NSDateFormatter*) dayMonthYearFormatter;
+ (NSDateFormatter*) hourminutesDateFormatter;
+ (NSDateFormatter*) weekDayNameFormatter;
+ (NSDateFormatter*) weekDayNunmberFormatter;
@end
