//
//  VenueViewController.h
//  Linz
//
//  Created by Ilter Cengiz on 11/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iCarousel;

@interface VenueViewController : UIViewController

@property (weak, nonatomic) IBOutlet iCarousel *carousel;

@property (weak, nonatomic) IBOutlet UITextView *headerTextView;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UITextView *linkTextView;

@end
