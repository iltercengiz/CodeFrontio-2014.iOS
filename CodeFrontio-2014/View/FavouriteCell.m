//
//  FavouriteCell.m
//  Linz
//
//  Created by Ilter Cengiz on 21/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Session.h"
#import "Speaker.h"

#pragma mark View
#import "FavouriteCell.h"
#import "GrabberView.h"

#pragma mark Pods
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <TMCache/TMDiskCache.h>

@interface FavouriteCell ()

@property (nonatomic) GrabberView *grabberView;

@end

@implementation FavouriteCell

#pragma mark - NSObject UIKit Additions
- (void)awakeFromNib {
    
    // Set background color for custom drawing
    self.backgroundColor = [UIColor clearColor];
    
    if (!self.grabberView) {
        self.grabberView = [[GrabberView alloc] initWithFrame:self.bounds];
        [self.contentView insertSubview:self.grabberView atIndex:0];
    }
    
}

#pragma mark - UIView
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.textLabel.frame = CGRectOffset(self.textLabel.frame, 24.0, -2.0);
        self.detailTextLabel.frame = CGRectOffset(self.detailTextLabel.frame, 24.0, -2.0);
    } else { // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.textLabel.frame = CGRectOffset(self.textLabel.frame, 8.0, 0.0);
        self.detailTextLabel.frame = CGRectOffset(self.detailTextLabel.frame, 8.0, 0.0);
    }
    
}

#pragma mark - FavouriteCell
- (void)configureCellForSession:(Session *)session {
    
    NSString *detailText;
    
    // Get Speaker(s)'s name(s)
    if ([session.speakerIdentifier isKindOfClass:[NSNumber class]]) {
        Speaker *speaker = [[Speaker MR_findByAttribute:@"identifier" withValue:session.speakerIdentifier] firstObject];
        detailText = speaker.name;
    } else if ([session.speakerIdentifier isKindOfClass:[NSArray class]]) {
        Speaker *firstSpeaker = [[Speaker MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", [session.speakerIdentifier firstObject]]] firstObject];
        Speaker *secondSpeaker = [[Speaker MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", [session.speakerIdentifier lastObject]]] firstObject];
        detailText = [NSString stringWithFormat:@"%@ & %@", firstSpeaker.name, secondSpeaker.name];
    }
    
    // Set title
    self.textLabel.text = session.title;
    
    // Set subtitle
    self.detailTextLabel.text = detailText;
    
    // Configure swipe stuff
    self.defaultColor = [UIColor lightGrayColor];
    self.shouldAnimateIcons = NO;
    
}

@end
