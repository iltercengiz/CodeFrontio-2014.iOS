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
#import "CalendarSessionCell.h"

#pragma mark Controller
#import "CalendarViewController.h"

#pragma mark Libraries
#import "RFQuiltLayout.h"

@interface CalendarViewController () <RFQuiltLayoutDelegate>

@property (nonatomic) NSArray *speakers;
@property (nonatomic) NSArray *sessions;

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
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [[LinzAPIClient sharedClient] GET:@"/data"
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  
                                  // Assign speakers
                                  self.speakers = responseObject[@"speakers"];
                                  
                                  // Loop through the sessions and add timeCell datas to the appropriate indexes
                                  NSArray *sessions = responseObject[@"sessions"];
                                  NSMutableArray *mutableSessions = [NSMutableArray array];
                                  for (NSDictionary *session in sessions) {
                                      // Add a small dictionary object to specify time cells
                                      // Check type and track values of the sessions for appropriate placing
                                      if ([session[@"type"] isEqualToNumber:@0] ||
                                          [session[@"track"] isEqualToNumber:@1]) // We check the track info instead of type to not to add time data twice for simultaneous sessions
                                      {
                                          [mutableSessions addObject:@{@"track": @0, @"type": @(-1)}];
                                      }
                                      // Add the session to array
                                      [mutableSessions addObject:session];
                                  }
                                  
                                  // Assign sessions
                                  self.sessions = mutableSessions;
                                  
                                  [self.collectionView reloadData];
                                  
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  NSLog(@"Error: %@", error.description);
                              }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewControllerDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sessions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *(^createTimeCell)() = ^UICollectionViewCell *(){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeCell" forIndexPath:indexPath];
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
