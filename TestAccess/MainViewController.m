//
//  MainViewController.m
//  TestAccess
//
//  Created by USER on 6/30/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "MainViewController.h"
#import "CalendarCollectionViewCell.h"
#import "CalendarDataSource.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "Event.h"
#import "EventViewLayout.h"
#import "HourReusableView.h"
#import "EventViewCell.h"
#import "EventStore.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, EventViewLayoutDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *calendarCollectionView;
@property (strong, nonatomic) EKEventStore* eventStore;
@property (strong, nonatomic) CalendarDataSource* calendarDataManeger;
@property (strong, nonatomic) NSMutableArray<Event*>* eventsForCurrentDay;
@property (strong, nonatomic) UICollectionView* eventCollectionView;
@property (strong, nonatomic) EKCalendar* calendar;

@end

static NSString* CALENDAR_CELL_IDENTIFIER = @"CalendarCollectionViewCell";
static NSString* EVENT_CELL_IDENTIFIER = @"EventCollectionViewCell";
static NSString* HOUR_VIEW_IDENTIFIER = @"HourView";

@implementation MainViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTitle];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(calendarCellWasSelected:)
                                                 name:CalendarCollectionViewCellWasSelectedNotification
                                               object:nil];
    
    self.eventsForCurrentDay = [NSMutableArray new];
    
    self.calendarDataManeger = [[CalendarDataSource alloc] init];
    self.calendarDataManeger.calendarCollectionView = self.calendarCollectionView;
    self.calendarCollectionView.pagingEnabled = YES;
    self.calendarCollectionView.showsHorizontalScrollIndicator = NO;
    self.calendarCollectionView.showsVerticalScrollIndicator = NO;
    self.calendarCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.calendarCollectionView.allowsSelection = YES;
    self.calendarCollectionView.dataSource = self.calendarDataManeger;
    self.calendarCollectionView.delegate = self.calendarDataManeger;
    [self.calendarCollectionView registerClass:[CalendarCollectionViewCell class] forCellWithReuseIdentifier:CALENDAR_CELL_IDENTIFIER];

    
    EventViewLayout *layout = [EventViewLayout new];
    self.eventCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.eventCollectionView registerClass:[EventViewCell class] forCellWithReuseIdentifier:EVENT_CELL_IDENTIFIER];
    [self.eventCollectionView registerClass:[HourReusableView class] forSupplementaryViewOfKind:HOUR_VIEW_IDENTIFIER withReuseIdentifier:HOUR_VIEW_IDENTIFIER];
    self.eventCollectionView.backgroundColor = [UIColor whiteColor];
    self.eventCollectionView.dataSource = self;
    self.eventCollectionView.delegate = self;
    [self.view addSubview:self.eventCollectionView];
    
    
    [self setUpConstraintsForEventsView];
    [self setUpConstraintsForCalendarView];
    
    
    [self checkPermissionForCNContacts];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.eventsForCurrentDay.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EventViewCell *view = [collectionView dequeueReusableCellWithReuseIdentifier:EVENT_CELL_IDENTIFIER forIndexPath:indexPath];
    view.event = [self eventAtIndex:indexPath.item];
    return view;
}

#pragma mark - Delegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HourReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HOUR_VIEW_IDENTIFIER forIndexPath:indexPath];
    if (indexPath.item % 4 == 0) {
        [view setTime:[NSString stringWithFormat:@"%@:00", @(indexPath.item / 4)]];
    }else {
        [view setTime:@""];
    }
    return view;
}

- (NSRange)calendarViewLayout:(EventViewLayout *)layout timespanForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return [self eventAtIndex:indexPath.item].timespan;
}


#pragma mark - CheckPermission

- (void)checkPermissionForCNContacts
{
    switch ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent])
    {
        case EKAuthorizationStatusNotDetermined:
        {
            self.calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.eventStore];
            [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    self.eventStore = [EventStore getInstance];
                    [self getEventsForDate:[NSDate date]];
                }
            }];
        }
            break;
        case EKAuthorizationStatusRestricted:
        case EKAuthorizationStatusDenied:
            break;
        case EKAuthorizationStatusAuthorized:
            self.eventStore = [EventStore getInstance];
            [self getEventsForDate:[NSDate date]];
            break;
    }
}

#pragma mark - Notification

- (void) calendarCellWasSelected:(NSNotification*) notification {
    if([[notification name] isEqualToString:CalendarCollectionViewCellWasSelectedNotification]) {
        NSDate* currentDate = [notification.userInfo objectForKey:CalendarCollectionViewCellWasSelectedNotificationKey];
        [self getEventsForDate:currentDate];
    }
}

#pragma mark - Events

- (void) getEventsForDate:(NSDate*) date {
    [self.eventsForCurrentDay removeAllObjects];
    NSCalendar* calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    [calendar setFirstWeekday:2];
    
    NSDate *startDate = [calendar dateBySettingHour:0  minute:0  second:0  ofDate:date options:0];
    NSDate *endDate   = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];

    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                        endDate:endDate
                                                                        calendars:nil];

    NSArray<EKEvent*>* events = [self.eventStore eventsMatchingPredicate:predicate];
        
    for (EKEvent* event in events) {
        NSRange timespan = [self rangeFrom:event.startDate endDate:event.endDate];
        UIColor *calendarColor = [UIColor colorWithCGColor:event.calendar.CGColor];
        Event* todayEvent = [Event eventWithTitle:event.title timespan:timespan color:calendarColor];
            
        [self.eventsForCurrentDay addObject:todayEvent];
    }
    [self.eventCollectionView reloadData];
}

- (Event *)eventAtIndex:(NSInteger)index {
    return self.eventsForCurrentDay[index];
}


- (NSRange) rangeFrom:(NSDate*) startDate endDate:(NSDate*) endDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *startDateComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate];
    NSInteger startHour = [startDateComponents hour];
    NSInteger startMinute = [startDateComponents minute];
    
    NSDateComponents *endDateComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:endDate];
    NSInteger endHour = [endDateComponents hour];
    NSInteger endMinute = [endDateComponents minute];
    
    NSUInteger loc = startHour * 60 + startMinute;
    NSUInteger len = endHour * 60 + endMinute - loc;

    return NSMakeRange(loc, len);
}

#pragma mark - Title

- (void) setUpTitle {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"d MMMM yyyy";
    self.title = [dateFormatter stringFromDate:[NSDate date]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blueColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
}

#pragma mark - constraints

- (void) setUpConstraintsForCalendarView {
    self.calendarCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.calendarCollectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.calendarCollectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.calendarCollectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.calendarCollectionView.heightAnchor constraintEqualToConstant:60]
                                              ]];
}

- (void) setUpConstraintsForEventsView {
    self.eventCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.eventCollectionView.topAnchor constraintEqualToAnchor:self.calendarCollectionView.bottomAnchor],
                                              [self.eventCollectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                                              [self.eventCollectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.eventCollectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              ]];
}






















@end
