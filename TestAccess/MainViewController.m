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
#import "UIColor+CustomColor.h"
#import "NSCalendar+CustomCalendar.h"
#import "NSDateFormatter+CustomDateFormatter.h"
#import "NSDate+CustomDate.m"
#import "EventRepository.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, EventViewLayoutDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *calendarCollectionView;
@property (strong, nonatomic) UICollectionView* eventCollectionView;
@property (strong, nonatomic) EKEventStore* eventStore;
@property (strong, nonatomic) EventRepository* eventRepository;
@property (strong, nonatomic) NSMutableArray<Event*>* eventsForCurrentDay;
@property (strong, nonatomic) CalendarDataSource* calendarDataSource;
@property (strong, nonatomic) UIView* currentTimeLine;
@property (strong, nonatomic) UILabel* currentTimeDate;
@end

static NSString* CALENDAR_CELL_IDENTIFIER = @"CalendarCollectionViewCell";
static NSString* EVENT_CELL_IDENTIFIER = @"EventCollectionViewCell";
static NSString* HOUR_VIEW_IDENTIFIER = @"HourView";

@implementation MainViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventStore = [EventStore getInstance];
    [self setUpTitle:[NSDate date]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(calendarCellWasSelected:)
                                                 name:CalendarDataSourceCellWasSelectedNotification
                                               object:nil];
    
    self.eventsForCurrentDay = [NSMutableArray new];
    [self initCollectionViews];
    [self setUpConstraintsForEventsView];
    [self setUpConstraintsForCalendarView];
    [self initTimeLine];
    
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];

    [self checkPermissionForCNContacts];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.eventsForCurrentDay.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EventViewCell *view = [collectionView dequeueReusableCellWithReuseIdentifier:EVENT_CELL_IDENTIFIER forIndexPath:indexPath];
    view.event = [self eventAtIndex:indexPath.item];
    return view;
}

#pragma mark - Delegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    HourReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HOUR_VIEW_IDENTIFIER forIndexPath:indexPath];
    if (indexPath.item % 4 == 0) {
        [view setTime:[NSString stringWithFormat:@"%@:00", @(indexPath.item / 4)]];
    } else {
        [view setTime:@""];
    }
    
    return view;
}

- (NSRange)calendarViewLayout:(EventViewLayout*)layout timespanForCellAtIndexPath:(NSIndexPath *)indexPath {
    return [self eventAtIndex:indexPath.item].timespan;
}


#pragma mark - CheckPermission

- (void)checkPermissionForCNContacts {
    switch ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent])
    {
        case EKAuthorizationStatusRestricted:
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusNotDetermined:
        {
            [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    self.eventRepository = [[EventRepository alloc] initWithEventStore:self.eventStore];
                    [self getEventsForDate:[NSDate date]];
                }
            }];
        }
            break;
        case EKAuthorizationStatusAuthorized:
            self.eventRepository = [[EventRepository alloc] initWithEventStore:self.eventStore];
            [self getEventsForDate:[NSDate date]];
            break;
    }
}

#pragma mark - CurrentTimeLine

- (void)timerFired:(NSTimer*) timer {
    [UIView animateWithDuration:0.3 animations:^{
        self.currentTimeLine.frame = CGRectMake(self.currentTimeLine.frame.origin.x, self.currentTimeLine.frame.origin.y + 3.4, self.currentTimeLine.frame.size.width, self.currentTimeLine.frame.size.height);
        
        self.currentTimeDate.frame = CGRectMake(self.currentTimeDate.frame.origin.x, self.currentTimeDate.frame.origin.y + 3.4, self.currentTimeDate.frame.size.width, self.currentTimeDate.frame.size.height);
        self.currentTimeDate.text = [NSDate strFromCurrentDate];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Notification

- (void) calendarCellWasSelected:(NSNotification*) notification {
    if([[notification name] isEqualToString:CalendarDataSourceCellWasSelectedNotification]) {
        NSDate* currentDate = [notification.userInfo objectForKey:CalendarDataSourceCellWasSelectedNotificationKey];
        [self setUpTitle:currentDate];
        [self getEventsForDate:currentDate];
        [self.eventCollectionView reloadData];
    }
}

#pragma mark - Events

- (void) getEventsForDate:(NSDate*) date {
    [self.eventsForCurrentDay removeAllObjects];
    NSArray<EKEvent*>* events = [self.eventRepository getEventsForDate:date];
        
    for (EKEvent* event in events) {
        NSRange timespan = [NSDate rangeFrom:event.startDate endDate:event.endDate];
        UIColor *calendarColor = [UIColor colorWithCGColor:event.calendar.CGColor];
        Event* todayEvent = [Event eventWithTitle:event.title timespan:timespan color:calendarColor];
            
        [self.eventsForCurrentDay addObject:todayEvent];
    }
    [self.eventCollectionView reloadData];
}

- (Event *)eventAtIndex:(NSInteger)index {
    return self.eventsForCurrentDay[index];
}

#pragma mark - Title

- (void) setUpTitle:(NSDate*) date {
    self.title = [[NSDateFormatter dayMonthYearFormatter] stringFromDate:date];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor blueDark]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor white], NSFontAttributeName:[UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold]}];
}

#pragma mark - TimeLineInit

- (void) initTimeLine {
    self.currentTimeLine = [[UIView alloc] initWithFrame:CGRectMake(55, [NSDate convertToMinutes:[NSDate date]] * 3 + 6, CGRectGetWidth(self.view.bounds), 3.4)];
    self.currentTimeLine.backgroundColor = [UIColor red];
    [self.eventCollectionView addSubview:self.currentTimeLine];
    
    self.currentTimeDate = [[UILabel alloc] initWithFrame:CGRectMake(10, [NSDate convertToMinutes:[NSDate date]] * 3 - 12, 50, 15)];
    self.currentTimeDate.backgroundColor = [UIColor white];
    self.currentTimeDate.text = [NSDate strFromCurrentDate];
    [self.eventCollectionView addSubview:self.currentTimeDate];
    
}

#pragma mark - CollectionViewInit

- (void) initCollectionViews {
    self.calendarDataSource = [[CalendarDataSource alloc] init];
    self.calendarDataSource.calendarCollectionView = self.calendarCollectionView;
    self.calendarCollectionView.pagingEnabled = YES;
    self.calendarCollectionView.showsHorizontalScrollIndicator = NO;
    self.calendarCollectionView.showsVerticalScrollIndicator = NO;
    [self.calendarCollectionView setShowsHorizontalScrollIndicator:NO];
    [self.calendarCollectionView setShowsVerticalScrollIndicator:NO];
    self.calendarCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.calendarCollectionView.allowsSelection = YES;
    self.calendarCollectionView.dataSource = self.calendarDataSource;
    self.calendarCollectionView.delegate = self.calendarDataSource;
    [self.calendarCollectionView registerClass:[CalendarCollectionViewCell class] forCellWithReuseIdentifier:CALENDAR_CELL_IDENTIFIER];
    
    
    EventViewLayout *layout = [EventViewLayout new];
    self.eventCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.eventCollectionView registerClass:[EventViewCell class] forCellWithReuseIdentifier:EVENT_CELL_IDENTIFIER];
    [self.eventCollectionView registerClass:[HourReusableView class] forSupplementaryViewOfKind:HOUR_VIEW_IDENTIFIER withReuseIdentifier:HOUR_VIEW_IDENTIFIER];
    self.eventCollectionView.backgroundColor = [UIColor whiteColor];
    self.eventCollectionView.dataSource = self;
    self.eventCollectionView.delegate = self;
    [self.view addSubview:self.eventCollectionView];
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
