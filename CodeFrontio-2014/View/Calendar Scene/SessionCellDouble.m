//
//  SessionCellDouble.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 15/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Categories
#import "UIColor+Palette.h"

#pragma mark Helpers
#import "DateFormatter.h"

#pragma mark Model
#import "Session.h"
#import "Speaker.h"

#pragma mark View
#import "SessionCellDouble.h"

#pragma mark Constants
#import "Constants.h"

#pragma mark Pods
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <TMCache/TMCache.h>

@interface SessionCellDouble ()

@property (nonatomic) Session *session;
@property (nonatomic) Speaker *firstSpeaker;
@property (nonatomic) Speaker *secondSpeaker;

- (IBAction)takeNote:(id)sender;
- (IBAction)favourite:(id)sender;

@end

@implementation SessionCellDouble

#pragma mark - NSObject UIKit Additions
- (void)awakeFromNib {
    
    self.layer.cornerRadius = 8.0;
    self.clipsToBounds = YES;
    
    self.firstPlaceholderImage.layer.cornerRadius = 8.0;
    self.firstPlaceholderImage.clipsToBounds = YES;
    
    self.secondPlaceholderImage.layer.cornerRadius = 8.0;
    self.secondPlaceholderImage.clipsToBounds = YES;
    
    self.takeNoteButton.backgroundColor = [UIColor P_lightBlueColor];
    self.favouriteButton.backgroundColor = [UIColor P_lightBlueColor];
    
    self.takeNoteButton.layer.cornerRadius = 4.0;
    self.favouriteButton.layer.cornerRadius = 4.0;
    
    self.takeNoteButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 12.0);
    self.favouriteButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 12.0);
    
    self.takeNoteButton.titleEdgeInsets = UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0);
    self.favouriteButton.titleEdgeInsets = UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0);
    
    [self.firstPlaceholderImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFirstSpeakerDetails:)]];
    [self.firstSpeakerNameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFirstSpeakerDetails:)]];
    
    [self.secondPlaceholderImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSecondSpeakerDetails:)]];
    [self.secondSpeakerNameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSecondSpeakerDetails:)]];
    
}

#pragma mark - UITableViewCell
- (void)prepareForReuse {
    
    self.timeLabel.text = nil;
    
    self.firstPlaceholderImage.image = [UIImage imageNamed:@"Speaker-placeholder"];
    self.secondPlaceholderImage.image = [UIImage imageNamed:@"Speaker-placeholder"];
    
    self.firstSpeakerNameLabel.text = nil;
    self.secondSpeakerNameLabel.text = nil;
    
    self.detailTextLabel.text = nil;
    
    self.favouriteButton.selected = NO;
    
}

#pragma mark - SessionCellDouble
- (void)configureCellForSession:(Session *)session {
    
    // Assign session and speakers
    self.session = session;
    self.firstSpeaker = [[Speaker MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", [session.speakerIdentifier firstObject]]] firstObject];
    self.secondSpeaker = [[Speaker MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", [session.speakerIdentifier lastObject]]] firstObject];
    
    // Set time
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.session.timeInterval doubleValue]];
    self.timeLabel.text = [[DateFormatter sharedFormatter] stringFromDate:date];
    
    // Set image
    __weak UIImageView *weakImageView;
    __weak NSString *weakString;
    
    weakImageView = self.firstPlaceholderImage;
    weakString = self.firstSpeaker.avatar;
    
    void (^setImage)(UIImageView *imageView, UIImage *image) = ^(UIImageView *imageView, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:imageView
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                imageView.image = image;
                            } completion:^(BOOL finished) {
                                
                            }];
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[TMCache sharedCache] objectForKey:weakString
                                      block:^(TMCache *cache, NSString *key, id object) {
                                          UIImage *image = object;
                                          if (image)
                                              setImage(weakImageView, image);
                                          else {
                                              NSURL *imageURL = [NSURL URLWithString:weakString];
                                              NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
                                              [weakImageView setImageWithURLRequest:request
                                                                   placeholderImage:nil
                                                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                setImage(weakImageView, image);
                                                                                [cache setObject:image forKey:weakString];
                                                                            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {}];
                                          }
                                      }];
    });
    
    weakImageView = self.secondPlaceholderImage;
    weakString = self.secondSpeaker.avatar;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[TMCache sharedCache] objectForKey:weakString
                                      block:^(TMCache *cache, NSString *key, id object) {
                                          UIImage *image = object;
                                          if (image)
                                              setImage(weakImageView, image);
                                          else {
                                              NSURL *imageURL = [NSURL URLWithString:weakString];
                                              NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
                                              [weakImageView setImageWithURLRequest:request
                                                                   placeholderImage:nil
                                                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                setImage(weakImageView, image);
                                                                                [cache setObject:image forKey:weakString];
                                                                            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {}];
                                          }
                                      }];
    });
    
    // Set name
    self.firstSpeakerNameLabel.text = self.firstSpeaker.name;
    self.secondSpeakerNameLabel.text = self.secondSpeaker.name;
    
    // Set session detail
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:self.session.title
                                                                attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0],
                                                                             NSForegroundColorAttributeName: [UIColor P_blueColor]}];
    NSAttributedString *detail = [[NSAttributedString alloc] initWithString:self.session.detail
                                                                 attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]}];
    NSMutableAttributedString *mutableAttributedString = [NSMutableAttributedString new];
    [mutableAttributedString appendAttributedString:title];
    [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    [mutableAttributedString appendAttributedString:detail];
    
    self.sessionDetailLabel.attributedText = mutableAttributedString;
    
    // Set de/selected favourite button
    self.favouriteButton.selected = [self.session.favourited boolValue];
    
}

- (IBAction)showFirstSpeakerDetails:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:didSelectSpeakerNotification object:nil userInfo:@{@"speaker": self.firstSpeaker}];
}
- (IBAction)showSecondSpeakerDetails:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:didSelectSpeakerNotification object:nil userInfo:@{@"speaker": self.secondSpeaker}];
}

- (IBAction)takeNote:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:takeNoteNotification object:nil userInfo:@{@"session": self.session}];
}
- (IBAction)favourite:(id)sender {
    
    UIButton *favouriteButton = (UIButton *)sender;
    
    // De/select favourite button
    if (!favouriteButton.selected) {
        [self scheduleNotification];
    } else {
        [self cancelNotification];
    }
    
    favouriteButton.selected = !favouriteButton.selected;
    
}

#pragma mark - Helpers
- (void)scheduleNotification {
    
    // Change state of session's favourite attr.
    self.session.favourited = @YES;
    
    // Save db
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        // if (success) NSLog(@"Save successful!");
        // else NSLog(@"Save failed with error: %@", error);
    }];
    
    // Check if the session is in the future
    NSTimeInterval timeInterval = [self.session.timeInterval doubleValue] + 15 * 60 + 5; // 15 mins + 5 secs
    NSDate *sessionTime = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    if ([sessionTime compare:[NSDate date]] != NSOrderedDescending) {
        // This session is passed, so there won't be any notification for this session
        return;
    }
    
    // Create a local notification for the session
    UILocalNotification *notification = ({
        
        // Notification will be fired 15 mins before the session
        // The time interval since 1 Jan 2001 00:00:00
        NSTimeInterval timeInterval = [self.session.timeInterval doubleValue] - 15 * 60; // 15 mins
        
        // Notification
        UILocalNotification *notification = [UILocalNotification new];
        // Set the fireDate according to the timeInterval
        notification.fireDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
        // String to be shown as 'slide to <string>'
        notification.alertAction = NSLocalizedString(@"Show", nil);
        // Notification message
        notification.alertBody = self.session.title;
        // Notification's sound
        notification.soundName = UILocalNotificationDefaultSoundName;
        // Add the session's identifier to the notification's user info
        notification.userInfo = @{@"identifier": self.session.identifier};
        
        // Return the notification
        notification;
        
    });
    
    // Schedule local notification
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}
- (void)cancelNotification {
    
    // Change state of session's favourite attr.
    self.session.favourited = @NO;
    
    // Save db
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        // if (success) NSLog(@"Save successful!");
        // else NSLog(@"Save failed with error: %@", error);
    }];
    
    // Get all scheduled notifications
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    // Loop through them to get the notification of the session
    for (UILocalNotification *notification in notifications) {
        // If the identifiers are equal, it means that we found our lovely notification <3
        if ([notification.userInfo[@"identifier"] isEqualToNumber:self.session.identifier]) {
            // Remove the notification
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            // Break the loop
            break;
        }
    }
    
}

@end
