//
//  EventViewCell.h
//  TestAccess
//
//  Created by USER on 7/2/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;

@interface EventViewCell : UICollectionViewCell
@property (strong, nonatomic) Event* event;
@end
