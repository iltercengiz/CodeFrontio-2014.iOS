//
//  CalendarViewController.m
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Networking
#import "LinzAPIClient.h"

#pragma mark View
#import "CalendarTimeCell.h"
#import "CalendarSessionCell.h"

#pragma mark Controller
#import "CalendarViewController.h"

#pragma mark Libraries
#import "RFQuiltLayout.h"

@interface CalendarCollectionView : UICollectionView

@end

@implementation CalendarCollectionView

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path;
    
    // Background
    path = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor colorWithRed:0.255 green:0.255 blue:0.259 alpha:1] setFill];
    [path fill];
    
    // Dark place for time cells
    path = [UIBezierPath bezierPathWithRect:CGRectMake(0.0, 0.0, CGRectGetWidth(rect), 64.0)];
    [[UIColor colorWithRed:0.153 green:0.153 blue:0.157 alpha:1] setFill];
    [path fill];
    
    // Thin line below the 'dark place'
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, 64.0)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect), 64.0)];
    path.lineWidth = 1.0;
    [[UIColor colorWithRed:0.278 green:0.278 blue:0.282 alpha:1] setStroke];
    [path stroke];
    
}

@end

@interface CalendarViewController () <RFQuiltLayoutDelegate>

@end

@implementation CalendarViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    RFQuiltLayout *layout = (RFQuiltLayout *)self.collectionView.collectionViewLayout;
    layout.delegate = self;
    layout.blockPixels = CGSizeMake(128.0, 64.0);
    layout.direction = UICollectionViewScrollDirectionHorizontal;
    
    // Set background color of collectionView for custom drawing
    self.collectionView.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadCalendar {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewControllerDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sessions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CalendarTimeCell *(^createTimeCell)() = ^CalendarTimeCell *(){
        CalendarTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeCell" forIndexPath:indexPath];
        [cell configureCellForTimeInterval:0];
        return cell;
    };
    
    UICollectionViewCell *(^createActivityCell)() = ^UICollectionViewCell *(){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCell" forIndexPath:indexPath];
        return cell;
    };
    
    CalendarSessionCell *(^createSessionCell)() = ^CalendarSessionCell *(){
        CalendarSessionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SessionCell" forIndexPath:indexPath];
        [cell configureCellForSession:nil];
        return cell;
    };
    
    NSDictionary *session = self.sessions[indexPath.row];
    
    if ([session[@"type"] isEqualToNumber:@(-1)]) {
        return createTimeCell();
    } else if ([session[@"type"] isEqualToNumber:@0]) {
        return createActivityCell();
    } else {
        return createSessionCell();
    }
    
}

#pragma mark - UICollectionViewControllerDelegate


#pragma mark - RFQuiltLayoutDelegate
- (CGSize)blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Session data
    NSDictionary *session = self.sessions[indexPath.row];
    
    // Size
    CGSize size = CGSizeZero;
    
    if ([session[@"type"] isEqualToNumber:@(-1)]) {
        size = (CGSize){.width = 2.0, .height = 1.0};
    } else if ([session[@"type"] isEqualToNumber:@0]) {
        size = (CGSize){.width = 2.0, .height = 10.0};
    } else {
        size = (CGSize){.width = 2.0, .height = 5.0};
    }
    
    return size;
    
}

@end
