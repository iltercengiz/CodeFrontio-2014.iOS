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

#pragma mark Controller
#import "CalendarViewController.h"
#import "SessionViewController.h"

#pragma mark Pods
#import <SVProgressHUD/SVProgressHUD.h>

@interface CalendarViewController () <UIScrollViewDelegate>

@property (nonatomic) NSArray *speakers;
@property (nonatomic) NSArray *sessions;

@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic, assign, getter = isPageControlUsed) BOOL pageControlUsed;

@end

@implementation CalendarViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.title = NSLocalizedString(@"Calendar", nil);
    } else { // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.navigationItem.titleView = ({
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.frame = CGRectMake(0.0, 2.0, 200.0, 24.0);
            titleLabel.text = NSLocalizedString(@"Calendar", nil);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                                           UIViewAutoresizingFlexibleBottomMargin |
                                           UIViewAutoresizingFlexibleHeight);
            
            self.pageControl = [UIPageControl new];
            self.pageControl.numberOfPages = 4;
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
    layout.minimumInteritemSpacing = 16.0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(10.0, 20.0, 10.0, 20.0);
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"trackCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    void (^completion)() = ^{
        
        self.speakers = [Manager sharedManager].speakers;
        self.sessions = [Manager sharedManager].sessions;
        
        // Reload calendar
        [self.collectionView reloadData];
        
        // Dismiss progress hud
        [SVProgressHUD showSuccessWithStatus:nil];
        
    };
    
    // Initiate setup
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[Manager sharedManager] setupWithCompletion:completion];
    });
    
}
- (void)viewWillLayoutSubviews {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(280.0, CGRectGetHeight(self.collectionView.frame) - 20.0);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        layout.itemSize = CGSizeMake(280.0, CGRectGetWidth(self.collectionView.frame) - 20.0);
    }
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
    return 4.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"trackCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:indexPath.item * 60.0/255.0 alpha:1.0];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    self.pageControl.currentPage = floor((scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth) + 1;
    
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
    
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    self.pageControlUsed = YES;
    
}

@end
