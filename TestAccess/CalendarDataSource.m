//
//  CalendarDataSource.m
//  TestAccess
//
//  Created by USER on 6/30/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "CalendarDataSource.h"
#import "CalendarCollectionViewCell.h"

@interface CalendarDataSource ()
@property (assign, nonatomic) NSInteger indexOfCellBeforeDragging; 
@end

static NSString* CALENDAR_CELL_IDENTIFIER = @"CalendarCollectionViewCell";

@implementation CalendarDataSource

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.indexOfCellBeforeDragging = 0;
    }
    return self;
}

- (void) setCollectionView:(UICollectionView *)collectionView {
    
    _calendarCollectionView = collectionView;
    _calendarCollectionView.delegate = self;
    _calendarCollectionView.dataSource = self;
    [_calendarCollectionView registerClass:[CalendarCollectionViewCell class] forCellWithReuseIdentifier:CALENDAR_CELL_IDENTIFIER];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void) update {
    [self.calendarCollectionView reloadData];
}

#pragma mark - DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1000;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    CalendarCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CALENDAR_CELL_IDENTIFIER forIndexPath:indexPath];
    cell.numberOfDayLabel.text = [self stringDateForWeek:indexPath.section weekDay:indexPath.row];
    cell.dayNameLabel.text = [self stringWeekDayForWeek:indexPath.section weekDay:indexPath.row];
    cell.eventIndicatorView.backgroundColor = [UIColor blackColor];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d"];
    NSDate *date = [dateFormatter dateFromString:[self stringDateForWeek:indexPath.section weekDay:indexPath.row]];
    cell.currentDay = date;
    
    return cell;
}

#pragma mark - delegate

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.indexOfCellBeforeDragging = [self indexOfMajorCell];
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    // Stop scrollView sliding:
//    targetContentOffset->x = scrollView.contentOffset.x;
//    targetContentOffset->y = scrollView.contentOffset.y;
//
//    // calculate where scrollView should snap to:
//    NSInteger indexOfMajorCell = [self indexOfMajorCell];
//    CGFloat swipeVelocityThreshold = 0.5;
//
//    // calculate conditions:
//    BOOL hasEnoughVelocityToSlideToTheNextCell = velocity.x > swipeVelocityThreshold;
//    BOOL hasEnoughVelocityToSlideToThePreviousCell = self.indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold;
//    NSInteger majorCellIsTheCellBeforeDragging = indexOfMajorCell == self.indexOfCellBeforeDragging;
//    BOOL didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell);
//
//    UICollectionViewFlowLayout* collectionViewLayout = (UICollectionViewFlowLayout*)self.calendarCollectionView.collectionViewLayout;
//    if (didUseSwipeToSkipCell) {
//        NSInteger snapToIndex = self.indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1);
//        CGFloat toValue = collectionViewLayout.itemSize.width * (CGFloat)snapToIndex;
//
//        // Damping equal 1 => no oscillations => decay animation:
//
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//            scrollView.contentOffset = CGPointMake(toValue, 0);
//            [scrollView layoutIfNeeded];
//        } completion:nil];
//    } else {
//        // This is a much better way to scroll to a cell:
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:indexOfMajorCell inSection:0];
//        [collectionViewLayout.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    }
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
}

- (void)didTapOnImage:(UIStackView *)dayOfWeekView {
    NSLog(@"tap");
}

#pragma mark - calendar date

- (NSString *)stringDateForWeek:(NSUInteger)week weekDay:(NSUInteger)weekDay {
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setFirstWeekday:2];
    NSDateComponents *components = [calendar components:NSCalendarUnitYearForWeekOfYear|NSCalendarUnitYear|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:[NSDate date]];
    weekDay = weekDay+1 == 7 ? 0 : weekDay +1;
    [components setYearForWeekOfYear:2019];
    [components setWeekOfYear:week];
    [components setWeekday:weekDay+1];
    NSDate *date = [calendar dateFromComponents:components];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"ru"];
    [formatter setLocale:locale];
    [formatter setDateFormat:@"dd"];
    return [formatter stringFromDate:date];
}

- (NSString *)stringWeekDayForWeek:(NSUInteger)week weekDay:(NSUInteger)weekDay {
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setFirstWeekday:2];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:[NSDate date]];
    weekDay = weekDay+1 == 7 ? 0 : weekDay +1;
    [components setYear:2019];
    [components setWeekOfYear:week];
    [components setWeekday:weekDay+1];
    NSDate *date = [calendar dateFromComponents:components];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"ru"];
    [formatter setLocale:locale];
    [formatter setDateFormat:@"EE"];
    return [formatter stringFromDate:date];;
}

//- (NSInteger) indexOfMajorCell {
//    UICollectionViewFlowLayout* collectionViewLayout = (UICollectionViewFlowLayout*)self.calendarCollectionView.collectionViewLayout;
//    CGFloat itemWidth = collectionViewLayout.itemSize.width;
//    double proportionalOffset = collectionViewLayout.collectionView.contentOffset.x / itemWidth;
//    NSInteger index = round(proportionalOffset);
//    NSInteger safeIndex = MAX(0, index);
//    return safeIndex;
//}


@end
