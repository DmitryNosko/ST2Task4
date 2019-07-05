//
//  EventViewCell.m
//  TestAccess
//
//  Created by USER on 7/2/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "EventViewCell.h"
#import "Event.h"
#import "UIColor+CustomColor.h"

@interface EventViewCell()
@property (strong, nonatomic) UILabel* label;
@end

@implementation EventViewCell
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label = [UILabel new];
        self.label.font = [UIFont boldSystemFontOfSize:17];
        self.label.numberOfLines = 0;
        self.label.lineBreakMode = NSLineBreakByTruncatingHead;
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void) setEvent:(Event*)event {
    _event = event;
    self.layer.borderColor = event.color.CGColor;
    self.backgroundColor = [event.color colorWithAlphaComponent:0.5f];
    self.label.text = event.title;
    self.label.textColor = [UIColor black];
    [self setNeedsLayout];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGSize labelSize = [self.label sizeThatFits:CGSizeMake(self.bounds.size.width - 10.0f, MAXFLOAT)];
    self.label.frame = CGRectMake(8, 8, labelSize.width, labelSize.height);
}

@end

