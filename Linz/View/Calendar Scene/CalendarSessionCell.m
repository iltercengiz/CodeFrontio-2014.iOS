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

#pragma mark Constants
static const CGFloat cornerRadius = 0.0;
static const CGFloat borderWidth = 0.5;

@interface CalendarSessionCell ()

- (IBAction)favouriteTapped:(id)sender;

@property (nonatomic) Session *session;

@end

@implementation CalendarSessionCell

#pragma mark - CalendarSessionCell
- (void)configureCellForSession:(Session *)session {
    
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
    self.nameLabel.text = speaker.name;
    
    // Set session detail
    self.sessionDetail.text = session.detail;
    
    // Buttons
    self.takeNoteButton.layer.cornerRadius = cornerRadius;
    self.takeNoteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.takeNoteButton.layer.borderWidth = borderWidth;
    
    self.favouriteButton.layer.cornerRadius = cornerRadius;
    self.favouriteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.favouriteButton.layer.borderWidth = borderWidth;
    self.favouriteButton.selected = [session.favourited boolValue];
    
}

- (IBAction)favouriteTapped:(id)sender {
    
    // Change state of session's favourite attr.
    self.session.favourited = @(![self.session.favourited boolValue]);
    
    // Save db
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) NSLog(@"Save successful!");
        else NSLog(@"Save failed with error: %@", error);
    }];
    
    // De/Select favourite button
    self.favouriteButton.selected = [self.session.favourited boolValue];
    
}

@end
