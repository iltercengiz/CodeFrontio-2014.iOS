//
//  SponsorCell.m
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Sponsor.h"

#pragma mark View
#import "SponsorCell.h"

#pragma mark Pods
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <TMCache/TMDiskCache.h>

@implementation SponsorCell

#pragma mark - Configurator
- (void)configureCellForSponsor:(Sponsor *)sponsor {
    
    // Set image
    NSString *imageURLString = sponsor.imageURL;
    UIImage *image = (UIImage *)[[TMDiskCache sharedCache] objectForKey:imageURLString];
    
    if (image) {
        self.sponsorImage.image = image;
    } else {
        __weak typeof(self.imageView) weakImageView = self.sponsorImage;
        __weak typeof(imageURLString) weakImageURLString = imageURLString;
        
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
        
        [self.sponsorImage setImageWithURLRequest:request
                                 placeholderImage:[UIImage imageNamed:@"Placeholder"]
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              weakImageView.image = image;
                                              [[TMDiskCache sharedCache] setObject:image forKey:weakImageURLString];
                                          } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                              // NSLog(@"Error getting image: %@", error.description);
                                          }];
    }
    
}

#pragma mark - UIView
- (void)drawRect:(CGRect)rect {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    // Upper line
    [bezierPath moveToPoint:(CGPoint){0.0, 0.0}];
    [bezierPath addLineToPoint:(CGPoint){CGRectGetWidth(self.frame), 0.0}];
    
    // Lower line
    [bezierPath moveToPoint:(CGPoint){0.0, CGRectGetHeight(self.frame)}];
    [bezierPath addLineToPoint:(CGPoint){CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)}];
    
    [[UIColor lightGrayColor] setStroke];
    [bezierPath setLineWidth:0.5];
    [bezierPath stroke];
    
}

@end
