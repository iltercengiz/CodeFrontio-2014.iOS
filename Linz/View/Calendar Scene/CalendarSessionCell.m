//
//  CalendarSessionCell.m
//  Linz
//
//  Created by Ilter Cengiz on 11/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Session.h"
#import "Speaker.h"

#pragma mark View
#import "CalendarSessionCell.h"

#pragma mark Pods
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <TMCache/TMDiskCache.h>

#pragma mark Constants
static const CGFloat cornerRadius = 0.0;
static const CGFloat borderWidth = 0.5;

@interface CalendarSessionCell ()

- (IBAction)takeNoteTapped:(id)sender;
- (IBAction)favouriteTapped:(id)sender;

@property (weak, nonatomic) UICollectionView *collectionView;

@property (nonatomic) Session *session;

@end

@implementation CalendarSessionCell

#pragma mark - CalendarSessionCell
- (void)configureCellForSession:(Session *)session andCollectionView:(UICollectionView *)collectionView {
    
    // Assign the collectionView
    self.collectionView = collectionView;
    
    // Set background color for custom drawing
    self.backgroundColor = [UIColor whiteColor];
    
    // Set frame
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    
    // Assign session
    self.session = session;
    
    // Speaker of the session
    Speaker *speaker = [[Speaker MR_findByAttribute:@"identifier" withValue:session.speakerIdentifier] firstObject];
    
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
    self.nameLabel.text = speaker.name;
    
    // Set session detail
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:session.title
                                                                      attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0]}];
    NSAttributedString *detailString = [[NSAttributedString alloc] initWithString:session.detail
                                                                       attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
    
    NSMutableAttributedString *mutableAttributedString = [NSMutableAttributedString new];
    [mutableAttributedString appendAttributedString:titleString];
    [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    [mutableAttributedString appendAttributedString:detailString];
    
    self.sessionDetail.attributedText = mutableAttributedString;
    
    // Buttons
    self.takeNoteButton.layer.cornerRadius = cornerRadius;
    self.takeNoteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.takeNoteButton.layer.borderWidth = borderWidth;
    
    self.favouriteButton.layer.cornerRadius = cornerRadius;
    self.favouriteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.favouriteButton.layer.borderWidth = borderWidth;
    self.favouriteButton.selected = [session.favourited boolValue];
    
}

#pragma mark - IBAction
- (IBAction)takeNoteTapped:(id)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:self];
    [self.collectionView.delegate collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}
- (IBAction)favouriteTapped:(id)sender {
    
    UIButton *favouriteButton = (UIButton *)sender;
    
    // De/Select favourite button
    if (!favouriteButton.selected) {
        favouriteButton.selected = [self scheduleNotification];
    } else {
        favouriteButton.selected = NO;
        [self cancelNotification];
    }
    
}

#pragma mark - Helpers
- (BOOL)scheduleNotification {
    
    NSTimeInterval timeInterval = [self.session.timeInterval doubleValue] + 15 * 60 + 5; // 15 mins + 5 secs
    NSDate *sessionTime = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    // Check if the session is in the future
    if ([sessionTime compare:[NSDate date]] != NSOrderedDescending) {
        // Inform user with an alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"Date passed error", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
        // Return
        return NO;
    }
    
    // Change state of session's favourite attr.
    self.session.favourited = @YES;
    
    // Save db
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        // if (success) NSLog(@"Save successful!");
        // else NSLog(@"Save failed with error: %@", error);
    }];
    
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
    
    // Return
    return YES;
    
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
