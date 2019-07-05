//
//  NSDateFormatter+CustomDateFormatter.m
//  TestAccess
//
//  Created by USER on 7/5/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "NSDateFormatter+CustomDateFormatter.h"

@implementation NSDateFormatter (CustomDateFormatter)

+ (NSDateFormatter*) dayMonthYearFormatter {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"d MMMM yyyy"];
    [df setLocale:[NSLocale localeWithLocaleIdentifier: @"ru_RU"]];
    return df;
}

+ (NSDateFormatter*) hourminutesDateFormatter {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    return df;
}

+ (NSDateFormatter*) weekDayNameFormatter {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"ru"];
    [df setLocale:locale];
    [df setDateFormat:@"EE"];
    return df;
}

+ (NSDateFormatter*) weekDayNunmberFormatter {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"ru"];
    [df setLocale:locale];
    [df setDateFormat:@"dd"];
    return df;
}

@end
