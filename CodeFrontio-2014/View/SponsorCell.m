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

#pragma mark - NSObject UIKit Additions
- (void)awakeFromNib {
    
    // Set background color
    self.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - Configurator
- (void)configureCellForSponsor:(Sponsor *)sponsor {
    
    // Set image
    NSString *imageURLString = [@"http://codefront.io/public/images/sponsors" stringByAppendingString:sponsor.imageURL];
    UIImage *image = (UIImage *)[[TMDiskCache sharedCache] objectForKey:imageURLString];
    
    if (image) {
        
        self.sponsorImage.image = image;
        
        if (CGRectGetWidth(self.sponsorImage.bounds) < image.size.width || CGRectGetHeight(self.sponsorImage.bounds) < image.size.height) {
            self.sponsorImage.contentMode = UIViewContentModeScaleAspectFit;
        }
        
    } else {
        
        __weak typeof(self.imageView) weakImageView = self.sponsorImage;
        __weak typeof(imageURLString) weakImageURLString = imageURLString;
        
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
        
        [self.sponsorImage setImageWithURLRequest:request
                                 placeholderImage:[UIImage imageNamed:@"Placeholder"]
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              
                                              if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 1) {
                                                  image = [image initWithCGImage:image.CGImage scale:2.0 orientation:UIImageOrientationUp];
                                              }
                                              
                                              weakImageView.image = image;
                                              
                                              if (CGRectGetWidth(weakImageView.bounds) < image.size.width || CGRectGetHeight(weakImageView.bounds) < image.size.height) {
                                                  weakImageView.contentMode = UIViewContentModeScaleAspectFit;
                                              }
                                              
                                              // Cache the downloaded image
                                              [[TMDiskCache sharedCache] setObject:image forKey:weakImageURLString];
                                              
                                          } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                              // NSLog(@"Error getting image: %@", error.description);
                                          }];
        
    }
    
}

@end
