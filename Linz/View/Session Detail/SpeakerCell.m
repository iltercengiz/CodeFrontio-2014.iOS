//
//  SpeakerCell.m
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Speaker.h"

#pragma mark View
#import "SpeakerCell.h"

#pragma mark Pods
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <TMCache/TMDiskCache.h>

@implementation SpeakerCell

#pragma mark - Configurator
- (void)configureCellForSpeaker:(Speaker *)speaker {
    
    // Set image
    self.imageView.layer.cornerRadius = 8.0;
    self.imageView.clipsToBounds = YES;
    
    NSString *imageURLString = speaker.avatar;
    UIImage *image = (UIImage *)[[TMDiskCache sharedCache] objectForKey:imageURLString];
    
    if (image) {
        self.imageView.image = image;
    } else {
        __weak typeof(self.imageView) weakImageView = self.imageView;
        __weak typeof(imageURLString) weakImageURLString = imageURLString;
        
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
        
        [self.imageView setImageWithURLRequest:request
                              placeholderImage:[UIImage imageNamed:@"image-placeholder"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           weakImageView.image = image;
                                           [[TMDiskCache sharedCache] setObject:image forKey:weakImageURLString];
                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           // NSLog(@"Error getting image: %@", error.description);
                                       }];
    }
    
    // Set name
    self.textLabel.text = speaker.name;
    
}

#pragma mark - UIView
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectInset(self.imageView.frame, 4.0, 4.0);
    
}

@end
