//
//  CalendarViewController.m
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Manager
#import "Manager.h"

#pragma mark Networking
#import "LinzAPIClient.h"

#pragma mark Model
#import "Session.h"
#import "Speaker.h"

#pragma mark View
#import "CalendarTimeCell.h"
#import "CalendarSessionCell.h"
#import "CalendarActivityCell.h"

#pragma mark Controller
#import "CalendarViewController.h"
#import "SessionViewController.h"

#pragma mark Libraries
#import "RFQuiltLayout.h"

#pragma mark Pods
#import <SVProgressHUD/SVProgressHUD.h>

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
    
    // Set background color of collectionView for custom drawing
    self.collectionView.backgroundColor = [UIColor clearColor];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // If setup is already done, reload and return
    if (self.speakers && self.sessions) {
        [self.collectionView reloadData];
        return;
    }
    
    // Show progress hud
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    void (^proceedBlock)(BOOL success) = ^(BOOL success){
        
        self.speakers = [Manager sharedManager].speakers;
        self.sessions = [Manager sharedManager].sessions;
        
        // Reload calendar
        [self.collectionView reloadData];
        
        // Dismiss progress hud
        [SVProgressHUD showSuccessWithStatus:nil];
        
    };
    
    // Initiate setup
    [[Manager sharedManager] setupWithCompletion:proceedBlock];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sessionSegue"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        Session *session = self.sessions[indexPath.item];
        SessionViewController *svc = segue.destinationViewController;
        svc.session = session;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sessions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CalendarTimeCell *(^createTimeCell)(Session *session) = ^CalendarTimeCell *(Session *session) {
        CalendarTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeCell" forIndexPath:indexPath];
        [cell configureCellForSession:session];
        return cell;
    };
    
    CalendarActivityCell *(^createActivityCell)(Session *session) = ^CalendarActivityCell *(Session *session) {
        CalendarActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCell" forIndexPath:indexPath];
        [cell configureCellForSession:session];
        return cell;
    };
    
    CalendarSessionCell *(^createSessionCell)(Session *session, Speaker *speaker) = ^CalendarSessionCell *(Session *session, Speaker *speaker) {
        CalendarSessionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SessionCell" forIndexPath:indexPath];
        [cell configureCellForSession:session speaker:speaker collectionView:collectionView];
        return cell;
    };
    
    Session *session = self.sessions[indexPath.item];
    
    if ([session.track isEqualToNumber:@(SessionTypeBreak)]) {
        return createTimeCell(session);
    } else if ([session.track isEqualToNumber:@(SessionTypeActivity)]) {
        return createActivityCell(session);
    } else { // if ([session.track isEqualToNumber:@1] || [session.track isEqualToNumber:@2])
        Speaker *speaker = [[self.speakers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", session.speakerIdentifier]] firstObject];
        return createSessionCell(session, speaker);
    }
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Session *session = self.sessions[indexPath.item];
    if ([session.type isEqualToNumber:@1] && ![session.track isEqualToNumber:@(-1)]) {
        [self performSegueWithIdentifier:@"sessionSegue" sender:indexPath];
    }
}

#pragma mark - RFQuiltLayoutDelegate
- (CGSize)blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Session data
    Session *session = self.sessions[indexPath.row];
    
    // Size
    CGSize size = CGSizeZero;
    
    if ([session.track isEqualToNumber:@(SessionTypeBreak)]) { // Time cell level
        if ([session.type isEqualToNumber:@(-1)])
            size = (CGSize){.width = 1.0, .height = 1.0};
        else
            size = (CGSize){.width = 2.0, .height = 1.0};
    } else if ([session.track isEqualToNumber:@(SessionTypeActivity)]) { // Activity
        if ([session.type isEqualToNumber:@(-1)]) // Break, Lunch, etc.
            size = (CGSize){.width = 1.0, .height = 10.0};
        else // Registration, Welcome speech, etc.
            size = (CGSize){.width = 2.0, .height = 10.0};
    } else { // if ([session.track isEqualToNumber:@1] || [session.track isEqualToNumber:@2]) // Keynote
        size = (CGSize){.width = 2.0, .height = 5.0};
    }
    
    return size;
    
}

@end
