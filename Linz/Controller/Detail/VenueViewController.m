//
//  VenueViewController.m
//  Linz
//
//  Created by Ilter Cengiz on 11/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Controller
#import "VenueViewController.h"

#pragma mark Pods
#import <iCarousel/iCarousel.h>

@interface VenueViewController () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic) NSTimer *timer;
@property (nonatomic, getter = isAutoScrollEnabled) BOOL autoScrollEnabled;

@property (nonatomic) NSArray *images;

@end

@implementation VenueViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.carousel.dataSource = self;
    self.carousel.delegate = self;
    self.carousel.type = iCarouselTypeRotary;
    
    self.images = @[[UIImage imageNamed:@"VenueImages.bundle/venue-1.jpg"],
                    [UIImage imageNamed:@"VenueImages.bundle/venue-2.jpg"],
                    [UIImage imageNamed:@"VenueImages.bundle/venue-3.jpg"],
                    [UIImage imageNamed:@"VenueImages.bundle/venue-4.jpg"],
                    [UIImage imageNamed:@"VenueImages.bundle/venue-5.jpg"],
                    [UIImage imageNamed:@"VenueImages.bundle/venue-6.jpg"] ];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Start auto scroll
    [self enableAutoScroll];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    // Stop auto scroll
    [self disableAutoScroll];
    
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [self.carousel reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Timer stuff
- (void)enableAutoScroll {
    
    // Check if the auto scroll is already enabled by a drag or something(?)
    if ([self isAutoScrollEnabled]) {
        return;
    }
    
    // Set autoScrollEnabled
    self.autoScrollEnabled = YES;
    
    // Set timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(scrollToNextItem) userInfo:nil repeats:YES];
    
}
- (void)disableAutoScroll {
    
    // Set autoScrollEnabled
    self.autoScrollEnabled = NO;
    
    // Invalidate timer
    [self.timer invalidate];
    
}
- (void)scrollToNextItem {
    
    NSUInteger index = self.carousel.currentItemIndex;
    index++;
    
    if (index >= self.carousel.numberOfItems) {
        index = 0;
    }
    
    [self.carousel scrollToItemAtIndex:index animated:YES];
    
}

#pragma mark - iCarouselDataSource
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.images.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    
    if (!view) {
        view = [[UIImageView alloc] initWithFrame:CGRectInset(self.carousel.frame, 32.0, 0.0)];
        view.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"VenueImages.bundle/venue-%li.jpg", index + 1];
    ((UIImageView *)view).image = [UIImage imageNamed:imageName];
    
    return view;
    
}

#pragma mark - iCarouselDelegate
- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    // Disable auto scrolling as user started dragging
    [self disableAutoScroll];
}
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate {
    // Enable auto scrolling again
    [self enableAutoScroll];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    
    // Disable auto scrolling
    [self disableAutoScroll];
    
    // Enable auto scrolling again after 6 seconds
    [self performSelector:@selector(enableAutoScroll) withObject:nil afterDelay:6];
    
}

@end
