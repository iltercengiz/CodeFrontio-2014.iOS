//
//  AvatarView.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 14/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Categories
#import "UIColor+Palette.h"

#pragma mark Model
#import "Speaker.h"

#pragma mark View
#import "AvatarView.h"

#pragma mark Pods
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <TMCache/TMCache.h>

@implementation AvatarView

#pragma mark - NSObject UIKit Additions
- (void)awakeFromNib {
    
    self.imageView.layer.cornerRadius = 8.0;
    self.imageView.layer.borderColor = [UIColor P_lightGrayColor].CGColor;
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.clipsToBounds = YES;
    
}

#pragma mark - UICollectionReusableView
- (void)prepareForReuse {
    self.imageView.image = [UIImage imageNamed:@"Speaker-placeholder"];
}

#pragma mark - AvatarView
- (void)configureViewForSpeaker:(Speaker *)speaker {
    
    __weak typeof(self.imageView) weakImageView = self.imageView;
    __weak typeof(speaker.avatar) weakAvatar = speaker.avatar;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [[TMCache sharedCache] objectForKey:weakAvatar
                                      block:^(TMCache *cache, NSString *key, id object) {
                                          
                                          UIImage *image = object;
                                          
                                          if (image) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  weakImageView.image = image;
                                              });
                                          } else {
                                              
                                              NSURL *imageURL = [NSURL URLWithString:weakAvatar];
                                              NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
                                              
                                              [weakImageView setImageWithURLRequest:request
                                                                   placeholderImage:nil
                                                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                    weakImageView.image = image;
                                                                                });
                                                                                [cache setObject:image forKey:weakAvatar];
                                                                            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                
                                                                            }];
                                              
                                          }
                                          
                                      }];
        
    });
    
}

@end
