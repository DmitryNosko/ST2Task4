//
//  HourReusableView.m
//  TestAccess
//
//  Created by USER on 7/2/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "HourReusableView.h"

static const CGFloat HourReusableViewTimeLineTopPadding = 6.0f;

@interface HourReusableView()
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UIView *timeLineView;

@end

@implementation HourReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.timeLabel = [UILabel new];
        self.timeLabel.font = [UIFont systemFontOfSize:17];
        self.timeLabel.textColor = [UIColor blackColor];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.timeLabel];
        
        self.timeLineView = [UIView new];
        self.timeLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
        [self addSubview:self.timeLineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect timeLabelFrame = self.timeLabel.frame;
    timeLabelFrame.origin.x = 0;
    timeLabelFrame.origin.y = 20;
    timeLabelFrame.size.width = 50;
    self.timeLabel.frame = timeLabelFrame;
    
    CGRect timeLineFrame = CGRectMake(10, HourReusableViewTimeLineTopPadding, self.bounds.size.width, 0.3f);
    self.timeLineView.frame = timeLineFrame;
}

- (void)setTime:(NSString *)time {
    self.timeLabel.text = time;
    [self.timeLabel sizeToFit];
    [self setNeedsLayout];
}
@end

