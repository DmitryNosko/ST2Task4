//
//  CalendarDataSource.m
//  TestAccess
//
//  Created by USER on 6/30/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "CalendarDataSource.h"
#import "CalendarCollectionViewCell.h"
#import <EventKit/EventKit.h>
#import "NSDateFormatter+CustomDateFormatter.h"
#import "NSCalendar+CustomCalendar.h"
#import "NSDate+CustomDate.h"
#import "EventRepository.h"
#import "EventStore.h"

@interface CalendarDataSource ()
@property (assign, nonatomic) NSInteger indexOfCellBeforeDragging;
@property (strong, nonatomic) NSCalendar* calendar;
@property (strong, nonatomic) NSDateFormatter *weekDayNumberformatter;
@property (strong, nonatomic) NSDateFormatter *weekDayNameformatter;
@property (strong, nonatomic) EventRepository* eventRepository;
@property (assign, nonatomic) NSInteger lastHighlightedSection;
@end

static NSString* CALENDAR_CELL_IDENTIFIER = @"CalendarCollectionViewCell";

NSString* const CalendarDataSourceCellWasSelectedNotification = @"CalendarCollectionViewCellWasSelectedNotification";
NSString* const CalendarDataSourceCellWasSelectedNotificationKey = @"CalendarCollectionViewCellWasSelectedNotificationKey";

@implementation CalendarDataSource

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lastHighlightedSection = -1;
        self.eventRepository = [[EventRepository alloc] initWithEventStore:[EventStore getInstance]];
        self.calendar = [NSCalendar gregorianCalendar];
        self.weekDayNameformatter = [NSDateFormatter weekDayNameFormatter];
        self.weekDayNumberformatter = [NSDateFormatter weekDayNunmberFormatter];
        self.indexOfCellBeforeDragging = 0;
    }
    return self;
}

- (void) setCollectionView:(UICollectionView *)collectionView {
    _calendarCollectionView = collectionView;
    _calendarCollectionView.delegate = self;
    _calendarCollectionView.dataSource = self;
    [_calendarCollectionView registerClass:[CalendarCollectionViewCell class] forCellWithReuseIdentifier:CALENDAR_CELL_IDENTIFIER];
}

#pragma mark - DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return INFINITY;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CalendarCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CALENDAR_CELL_IDENTIFIER forIndexPath:indexPath];
    
    NSDate* currentDate = [NSDate getChoosenDate:indexPath.section weekDay:indexPath.row];
    cell.numberOfDayLabel.text = [NSDate getDayNumber:currentDate];
    cell.dayNameLabel.text = [NSDate getDayName:currentDate];
    cell.eventIndicatorView.hidden = ![self.eventRepository hasEventsAtDate:currentDate];
    cell.currentDate = currentDate;
    
    if ((self.lastHighlightedSection == indexPath.row)) {
        [cell setSelected:YES];
        NSDictionary* dictionary = [NSDictionary dictionaryWithObject:cell.currentDate forKey:CalendarDataSourceCellWasSelectedNotificationKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:CalendarDataSourceCellWasSelectedNotification
                                                            object:nil
                                                          userInfo:dictionary];
    }
    
    return cell;
}

#pragma mark - delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.calendarCollectionView reloadData];
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (NSUInteger)maximumNumberOfColumnsForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout {
    return 7;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarCollectionViewCell* cell = (CalendarCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:cell.currentDate forKey:CalendarDataSourceCellWasSelectedNotificationKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:CalendarDataSourceCellWasSelectedNotification
                                                        object:nil
                                                      userInfo:dictionary];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    self.lastHighlightedSection = indexPath.row;
}

- (CGFloat)widthOfDayCell {
    int cellsPerPage = 7;
    return self.calendarCollectionView.bounds.size.width / cellsPerPage;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self widthOfDayCell], 60);
}

@end































