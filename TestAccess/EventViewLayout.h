//
//  EventViewLayout.h
//  TestAccess
//
//  Created by USER on 7/2/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventViewLayout : UICollectionViewLayout

@end

@protocol EventViewLayoutDelegate <NSObject>
- (NSRange)calendarViewLayout:(EventViewLayout*)layout timespanForCellAtIndexPath:(NSIndexPath *)indexPath;
@end
