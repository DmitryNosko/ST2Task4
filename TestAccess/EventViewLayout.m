//
//  EventViewLayout.m
//  TestAccess
//
//  Created by USER on 7/2/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "EventViewLayout.h"

static const CGFloat Multiply = 3;
static const CGFloat CalendarViewLayoutHourViewHeight = 15.0f * Multiply;
static const CGFloat CalendarViewLayoutLeftPadding = 60.0f;
static const CGFloat CalendarViewLayoutRightPadding = 10.0f;
static const CGFloat CalendarViewLayoutTimeLinePadding = 6.0f;
static NSString* HOUR_VIEW_IDENTIFIER = @"HourView";

@interface EventViewLayout ()
@property (nonatomic) NSMutableArray* cellAttributes;
@property (nonatomic) NSMutableArray* hourAttributes;
@property (nonatomic) UICollectionViewLayoutAttributes* lineAtribute;
@end

@implementation EventViewLayout

- (instancetype) init {
    if (self = [super init]) {
        self.cellAttributes = [NSMutableArray new];
        self.hourAttributes = [NSMutableArray new];
    }
    return self;
}

- (CGSize) collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, CalendarViewLayoutHourViewHeight * 96 + CalendarViewLayoutTimeLinePadding);
}

- (void) prepareLayout {
    [self.cellAttributes removeAllObjects];
    [self.hourAttributes removeAllObjects];
    
    if ([self.collectionView.delegate conformsToProtocol:@protocol(EventViewLayoutDelegate)]) {
        id <EventViewLayoutDelegate> calendarViewLayoutDelegate = (id <EventViewLayoutDelegate>)self.collectionView.delegate;
        
        for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
            for (NSInteger j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++) {
                NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:j inSection:i];
                NSRange timespan = [calendarViewLayoutDelegate calendarViewLayout:self timespanForCellAtIndexPath:cellIndexPath];

                CGFloat posY = timespan.location * 3 + CalendarViewLayoutTimeLinePadding;
                CGFloat height = timespan.length * 3;
                
                UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
                CGRect attributesFrame = attributes.frame;
                attributesFrame.origin = CGPointMake(CalendarViewLayoutLeftPadding, posY);
                attributesFrame.size = CGSizeMake(self.collectionView.bounds.size.width - CalendarViewLayoutRightPadding - CalendarViewLayoutLeftPadding, height);
                attributes.frame = attributesFrame;
                [self.cellAttributes addObject:attributes];
            

            }
        }
    }
    
    for (NSInteger i = 0; i < 96; i++) {
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:HOUR_VIEW_IDENTIFIER withIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        CGRect attributesFrame = CGRectZero;
        attributesFrame.size = CGSizeMake(self.collectionView.bounds.size.width, CalendarViewLayoutHourViewHeight);
        if (i == 95) {
            attributesFrame.size.height += CalendarViewLayoutTimeLinePadding;
        }
        attributesFrame.origin = CGPointMake(0, i * CalendarViewLayoutHourViewHeight);
        attributes.frame = attributesFrame;
        [self.hourAttributes addObject:attributes];
    }
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray new];
    
    for (UICollectionViewLayoutAttributes *attributes in self.cellAttributes) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }
    
    for (UICollectionViewLayoutAttributes *attributes in self.hourAttributes) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }
    
    return allAttributes;
}


@end
