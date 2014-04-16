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

#pragma mark Categories
#import "UIColor+Palette.h"

#pragma mark Model
#import "Session.h"
#import "Speaker.h"

#pragma mark View
#import "TrackCell.h"

#pragma mark Controller
#import "CalendarViewController.h"
#import "SessionViewController.h"
#import "SpeakerViewController.h"

#pragma mark Constants
#import "Constants.h"

#pragma mark Pods
#import <SVProgressHUD/SVProgressHUD.h>

@interface CalendarViewController () <UIScrollViewDelegate>

@property (nonatomic) NSArray *speakers;
@property (nonatomic) NSDictionary *sessionsTracked;

@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic, assign, getter = isPageControlUsed) BOOL pageControlUsed;

@property (nonatomic) NSMutableDictionary *trackTableViews;

@end

@implementation CalendarViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Remove title from back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.title = NSLocalizedString(@"Calendar", nil);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        self.navigationItem.titleView = ({
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.frame = CGRectMake(0.0, 2.0, 200.0, 24.0);
            titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
            titleLabel.text = NSLocalizedString(@"Calendar", nil);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                                           UIViewAutoresizingFlexibleBottomMargin |
                                           UIViewAutoresizingFlexibleHeight);
            
            self.pageControl = [UIPageControl new];
            self.pageControl.frame = CGRectMake(0.0, 27.0, 200.0, 14.0);
            self.pageControl.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                                                 UIViewAutoresizingFlexibleBottomMargin |
                                                 UIViewAutoresizingFlexibleHeight);
            [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
            
            UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 44.0)];
            [titleView addSubview:titleLabel];
            [titleView addSubview:self.pageControl];
            titleView;
            
        });
        
    }
    
    // Collection view stuff
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0);
    
    self.collectionView.backgroundColor = [UIColor P_lightBlueColor];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.scrollsToTop = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeNote:) name:takeNoteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectSpeaker:) name:didSelectSpeakerNotification object:nil];
    
    // If setup is already done, reload and return
    if (self.speakers && self.sessionsTracked) {
        [self.collectionView reloadData];
        return;
    }
    
    // Show progress hud
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    void (^completion)() = ^{
        
        self.speakers = [Manager sharedManager].speakers;
        self.sessionsTracked = [Manager sharedManager].sessionsTracked;
        
        // Reload calendar
        [self.collectionView reloadData];
        
        // Set page number
        self.pageControl.numberOfPages = self.sessionsTracked.count;
        
        // Dismiss progress hud
        [SVProgressHUD showSuccessWithStatus:nil];
        
    };
    
    // Initiate setup
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[Manager sharedManager] setupWithCompletion:completion];
    });
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // Remove notification observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:takeNoteNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didSelectSpeakerNotification object:nil];
    
}
- (void)viewWillLayoutSubviews {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        layout.itemSize = CGSizeMake(320.0, CGRectGetHeight(self.collectionView.frame));
    } else { // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        layout.itemSize = CGSizeMake(280.0, CGRectGetHeight(self.collectionView.frame));
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        layout.itemSize = CGSizeMake(320.0, CGRectGetWidth(self.collectionView.frame));
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sessionSegue"]) {
        NSDictionary *userInfo = sender;
        SessionViewController *svc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UINavigationController *nc = segue.destinationViewController;
            svc = [nc.viewControllers firstObject];
        } else { // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            svc = segue.destinationViewController;
        }
        svc.session = userInfo[@"session"];
    } else if ([segue.identifier isEqualToString:@"speakerSegue"]) {
        NSDictionary *userInfo = (NSDictionary *)sender;
        SpeakerViewController *svc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UINavigationController *nc = segue.destinationViewController;
            svc = [nc.viewControllers firstObject];
        } else { // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            svc = segue.destinationViewController;
        }
        svc.speaker = userInfo[@"speaker"];
    }
}

#pragma mark - Notifications
- (void)takeNote:(NSNotification *)note {
    [self performSegueWithIdentifier:@"sessionSegue" sender:note.userInfo];
}
- (void)didSelectSpeaker:(NSNotification *)note {
    [self performSegueWithIdentifier:@"speakerSegue" sender:note.userInfo];
}

#pragma mark - Helper
- (void)enableScrollToTopForTrack:(NSInteger)track {
    
    // Disable scrollsToTop for all tableViews
    [self.trackTableViews enumerateKeysAndObjectsUsingBlock:^(NSNumber *track, UITableView *tableView, BOOL *stop) {
        tableView.scrollsToTop = NO;
    }];
    
    // Enable only for the current tableView
    UITableView *tableView = self.trackTableViews[@(track)];
    tableView.scrollsToTop = YES;
    
}

#pragma mark - Getter
- (NSMutableDictionary *)trackTableViews {
    if (!_trackTableViews) {
        _trackTableViews = [NSMutableDictionary dictionary];
    }
    return _trackTableViews;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sessionsTracked.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TrackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"trackCell" forIndexPath:indexPath];
    
    [cell configureCellForSessions:self.sessionsTracked[@(indexPath.item + 1)]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        [self.trackTableViews setObject:cell.tableView forKey:@(indexPath.item)];
        
        if (indexPath.item == self.pageControl.currentPage)
            [self enableScrollToTopForTrack:self.pageControl.currentPage];
        
    }
    
    return cell;
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // If we are on iPad, simply return
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used
    if ([self isPageControlUsed]) {
        return;
    }
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = 280.0;
    CGFloat pageSpacing = 10.0;
    
    pageWidth += pageSpacing;
    
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth) + 1;
    
    if (self.pageControl.currentPage != currentPage) {
        self.pageControl.currentPage = currentPage;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self enableScrollToTopForTrack:currentPage];
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    // If we are on iPad, simply return
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
    _pageControlUsed = NO;
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // If we are on iPad, simply return
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
    _pageControlUsed = NO;
    
}

#pragma mark - UIPageControl
- (IBAction)changePage:(id)sender {
    
    // Update the scroll view to the appropriate page
    NSInteger currentPage = ((UIPageControl *)sender).currentPage;
    
    CGFloat pageWidth = 280.0;
    CGFloat pageSpacing = 10.0;
    
    pageWidth += pageSpacing;
    
    CGRect frame = self.collectionView.frame;
    frame.origin.x = pageWidth * currentPage;
    frame.origin.y = 0.0;
    
    [self.collectionView scrollRectToVisible:frame animated:YES];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self enableScrollToTopForTrack:currentPage];
    }

    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    self.pageControlUsed = YES;
    
}

@end
