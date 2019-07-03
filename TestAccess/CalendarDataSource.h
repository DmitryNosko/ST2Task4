//
//  CalendarDataSource.h
//  TestAccess
//
//  Created by USER on 6/30/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CalendarDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionView * calendarCollectionView;
@end
