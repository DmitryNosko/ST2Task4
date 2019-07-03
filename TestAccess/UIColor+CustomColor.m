//
//  UIColor+CustomColor.m
//  TestAccess
//
//  Created by USER on 7/3/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "UIColor+CustomColor.h"

@implementation UIColor (CustomColor)

+ (UIColor *) gray {
    return [UIColor colorWithRed:0x85/255.0f green:0x90/255.0f blue:0xA6/255.0f alpha:1];
}

+ (UIColor *) black {
    return [UIColor colorWithRed:0x00/255.0f green:0x00/255.0f blue:0x00/255.0f alpha:1];;
}
+ (UIColor *) white {
    return [UIColor colorWithRed:0xFF/255.0f green:0xFF/255.0f blue:0xFF/255.0f alpha:1];;
}

+ (UIColor *) blueDark {
    return [UIColor colorWithRed:0x03/255.0f green:0x75/255.0f blue:0x94/255.0f alpha:1];
}

+ (UIColor *) grayDark {
    return [UIColor colorWithRed:0x38/255.0f green:0x38/255.0f blue:0x38/255.0f alpha:1];;
}

+ (UIColor *) grayLight {
    return [UIColor colorWithRed:0xC7/255.0f green:0xC7/255.0f blue:0xC8/255.0f alpha:1];
}

+ (UIColor *) red {
    return [UIColor colorWithRed:0xFC/255.0f green:0x67/255.0f blue:0x96/255.0f alpha:1];
}

@end
