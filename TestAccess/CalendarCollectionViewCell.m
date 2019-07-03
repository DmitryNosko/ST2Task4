//
//  CalendarCollectionViewCell.m
//  TestAccess
//
//  Created by USER on 7/1/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "CalendarCollectionViewCell.h"
#import "UIColor+CustomColor.h"


@interface CalendarCollectionViewCell ()
@property (strong, nonatomic) UIView* selectedView;
@end

@implementation CalendarCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}


- (void) setUp {
    
    self.contentView.backgroundColor = [UIColor blueDark];
    
    self.selectedView = [UIView new];
    self.selectedView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.selectedView];
    self.selectedView.backgroundColor = [UIColor red];
    self.selectedView.hidden = YES;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.selectedView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
                                              [self.selectedView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor constant:-5],
                                              [self.selectedView.widthAnchor constraintEqualToConstant:50.0f],
                                              [self.selectedView.heightAnchor constraintEqualToConstant:50.0f],
                                              ]
     ];
    self.selectedView.layer.cornerRadius = 50 / 2;
    self.selectedView.layer.masksToBounds = YES;
    
    self.numberOfDayLabel = [UILabel new];
    self.numberOfDayLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.numberOfDayLabel.font = [UIFont systemFontOfSize:17 weight: UIFontWeightSemibold];
    self.numberOfDayLabel.textColor = [UIColor white];
    self.numberOfDayLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.numberOfDayLabel];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.numberOfDayLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
                                              [self.numberOfDayLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor constant:-10],
                                              ]];
    
    self.dayNameLabel = [UILabel new];
    self.dayNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.dayNameLabel.font = [UIFont systemFontOfSize:12];
    self.dayNameLabel.textColor = [UIColor white];
    self.dayNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.dayNameLabel];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.dayNameLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
                                              [self.dayNameLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
                                              [self.dayNameLabel.topAnchor constraintEqualToAnchor:self.numberOfDayLabel.bottomAnchor],
                                              ]];
    
    
    self.eventIndicatorView = [UIView new];
    self.eventIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.eventIndicatorView.backgroundColor = [UIColor white];
    self.eventIndicatorView.hidden = YES;
    [self.contentView addSubview:self.eventIndicatorView];
    
    [NSLayoutConstraint activateConstraints:@[

                                              [self.eventIndicatorView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
                                              [self.eventIndicatorView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor constant:18],
                                              [self.eventIndicatorView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
                                              [self.eventIndicatorView.heightAnchor constraintEqualToConstant:5.0f],
                                              [self.eventIndicatorView.widthAnchor constraintEqualToConstant:13.0f]
                                              ]
     ];
    
    self.eventIndicatorView.layer.cornerRadius = 50 / 2;
    self.eventIndicatorView.layer.masksToBounds = YES;
    
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.selectedView.hidden = selected ? NO : YES;
}




@end




























