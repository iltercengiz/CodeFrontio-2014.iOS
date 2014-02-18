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

@implementation SpeakerCell

#pragma mark - Configurator
- (void)configureCellForSpeaker:(Speaker *)speaker {
    
    // Set image
    self.imageView.layer.cornerRadius = 8.0;
    self.imageView.clipsToBounds = YES;
    
    __weak typeof(self.imageView) weakImageView = self.imageView;
    
    NSString *imageURLString = speaker.avatar;
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    
    [self.imageView setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:@"Placeholder"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       // To-do: cache image
                                       weakImageView.image = image;
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       NSLog(@"Error getting image: %@", error.description);
                                   }];
    
    // Set name
    self.textLabel.text = speaker.name;
    
}

@end
