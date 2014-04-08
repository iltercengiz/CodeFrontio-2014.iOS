//
//  SessionCell.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 08/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Categories
#import "UIColor+Palette.h"

#pragma mark Model
#import "Session.h"
#import "Speaker.h"

#pragma mark View
#import "SessionCell.h"

#pragma mark Pods
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <TMCache/TMCache.h>

@interface SessionCell ()

@property (nonatomic) Session *session;
@property (nonatomic) Speaker *speaker;

- (IBAction)takeNote:(id)sender;
- (IBAction)favourite:(id)sender;

@end

@implementation SessionCell

#pragma mark - NSObject UIKit Additions
- (void)awakeFromNib {
    
    self.layer.cornerRadius = 6.0;
    self.clipsToBounds = YES;
    
    self.placeholderImage.layer.cornerRadius = 4.0;
    self.placeholderImage.layer.borderColor = [UIColor P_lightBlueColor].CGColor;
    self.placeholderImage.layer.borderWidth = 1.0;
    self.placeholderImage.clipsToBounds = YES;
    
    self.takeNoteButton.backgroundColor = [UIColor P_lightBlueColor];
    self.favouriteButton.backgroundColor = [UIColor P_lightBlueColor];
    
    self.takeNoteButton.layer.cornerRadius = 4.0;
    self.favouriteButton.layer.cornerRadius = 4.0;
    
}

#pragma mark - UITableViewCell
- (void)prepareForReuse {
    // Remove previous image
    self.placeholderImage.image = [UIImage imageNamed:@"image-placeholder"];
}

#pragma mark - SessionCell
- (void)configureCellForSession:(Session *)session {
    
    // Assign session and speaker
    self.session = session;
    self.speaker = [[Speaker MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", session.speakerIdentifier]] firstObject];
    
    // Set time
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.session.timeInterval doubleValue]];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeStyle = NSDateFormatterShortStyle;
    self.timeLabel.text = [formatter stringFromDate:date];
    
    // Set image
    __weak typeof(self.placeholderImage) weakPlaceholderImage = self.placeholderImage;
    __weak typeof(self.speaker.avatar) weakImageURLString = self.speaker.avatar;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [[TMCache sharedCache] objectForKey:weakImageURLString
                                      block:^(TMCache *cache, NSString *key, id object) {
                                          
                                          UIImage *image = object;
                                          
                                          if (image) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  weakPlaceholderImage.image = image;
                                              });
                                          } else {
                                              
                                              NSURL *imageURL = [NSURL URLWithString:weakImageURLString];
                                              NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
                                              
                                              [weakPlaceholderImage setImageWithURLRequest:request
                                                                          placeholderImage:nil
                                                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                                                           weakPlaceholderImage.image = image;
                                                                                       });
                                                                                       [cache setObject:image forKey:weakImageURLString];
                                                                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                       
                                                                                   }];
                                              
                                          }
                                          
                                      }];
        
    });
    
    // Set name
    self.speakerNameLabel.text = self.speaker.name;
    
    // Set session title
    self.sessionTitleLabel.text = self.session.title;
    
    // Set session detail
    self.sessionDetailLabel.text = self.session.detail;
    
    // Set de/selected favourite button
    self.favouriteButton.selected = [self.session.favourited boolValue];
    
}

- (IBAction)takeNote:(id)sender {
    NSLog(@"takeNote:");
}
- (IBAction)favourite:(id)sender {
    NSLog(@"favourite:");
}

@end
