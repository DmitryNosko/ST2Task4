//
//  Event.h
//  TestAccess
//
//  Created by USER on 7/1/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (assign, nonatomic) NSRange timespan;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) UIColor* color;

+ (Event *)eventWithTitle:(NSString*)title timespan:(NSRange)timespan color:(UIColor*)color;

@end
