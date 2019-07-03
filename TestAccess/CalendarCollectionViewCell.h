//
//  CalendarCollectionViewCell.h
//  TestAccess
//
//  Created by USER on 7/1/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UILabel* dayNameLabel;
@property (strong, nonatomic) UILabel* numberOfDayLabel;
@property (strong, nonatomic) UIView* eventIndicatorView;

@property (strong, nonatomic) NSDate *currentDay;
@end
