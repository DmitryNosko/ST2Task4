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
#import "EventStore.h"

@interface CalendarDataSource ()
@property (assign, nonatomic) NSInteger indexOfCellBeforeDragging;
@property (strong, nonatomic) NSCalendar* calendar;
@property (strong, nonatomic) NSDateFormatter *weekDayNumberformatter;
@property (strong, nonatomic) NSDateFormatter *weekDayNameformatter;
@property (strong, nonatomic) EKEventStore* eventStore;
@end

static NSString* CALENDAR_CELL_IDENTIFIER = @"CalendarCollectionViewCell";

@implementation CalendarDataSource

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.eventStore = [EventStore getInstance];
        
        self.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        [self.calendar setTimeZone:[NSTimeZone localTimeZone]];
        [self.calendar setFirstWeekday:2];
        
        NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"ru"];
        
        self.weekDayNumberformatter = [[NSDateFormatter alloc] init];
        [self.weekDayNumberformatter setLocale:locale];
        [self.weekDayNumberformatter setDateFormat:@"dd"];
        
        self.weekDayNameformatter = [[NSDateFormatter alloc] init];
        [self.weekDayNameformatter setLocale:locale];
        [self.weekDayNameformatter setDateFormat:@"EE"];
        
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return INFINITY;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CalendarCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CALENDAR_CELL_IDENTIFIER forIndexPath:indexPath];
    cell.numberOfDayLabel.text = [self getDayNumber:indexPath.section weekDay:indexPath.row];
    cell.dayNameLabel.text = [self getDayName:indexPath.section weekDay:indexPath.row];
    NSDate* currentDate = [self getChoosenDate:indexPath.section weekDay:indexPath.row];
    cell.eventIndicatorView.hidden = ![self hasEventsAtDate:currentDate];
    cell.currentDate = currentDate;
    
    return cell;
}

#pragma mark - delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.calendarCollectionView reloadData];
}

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

#pragma mark - date

- (NSString *)getDayNumber:(NSUInteger)scrollViewChoosenWeek weekDay:(NSUInteger)weekDayNumber {
    return [self.weekDayNumberformatter stringFromDate:[self getChoosenDate:scrollViewChoosenWeek weekDay:weekDayNumber]];
}

- (NSString *)getDayName:(NSUInteger)scrollViewChoosenWeek weekDay:(NSUInteger)weekDayNumber {
    return [self.weekDayNameformatter stringFromDate:[self getChoosenDate:scrollViewChoosenWeek weekDay:weekDayNumber]];
}

- (NSDate*) getChoosenDate:(NSUInteger)weekNumber weekDay:(NSUInteger)weekDayNumber {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYearForWeekOfYear|NSCalendarUnitYear|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:[NSDate date]];
    weekDayNumber = weekDayNumber + 1 == 7 ? 0 : weekDayNumber + 1;
    NSUInteger currentWeekOfYear = components.weekOfYear;
    [components setWeekOfYear:currentWeekOfYear + weekNumber];
    [components setWeekday:weekDayNumber + 1];
    return [self.calendar dateFromComponents:components];
}

#pragma mark - Has Event

- (BOOL) hasEventsAtDate:(NSDate*) date {
    
    NSDate *startDate = [self.calendar dateBySettingHour:0  minute:0  second:0  ofDate:date options:0];
    NSDate *endDate   = [self.calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];
    
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                            endDate:endDate
                                                                            calendars:nil];
    
    NSArray<EKEvent*>* events = [self.eventStore eventsMatchingPredicate:predicate];
    
    return events.count > 0;
}



@end































