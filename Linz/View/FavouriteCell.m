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

#pragma mark - Configurator
- (void)configureCellForSession:(Session *)session {
    
    // Speaker
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
    
    // Set title
    self.textLabel.text = session.title;
    
    // Set subtitle
    self.detailTextLabel.text = speaker.name;
    
    // Configure swipe stuff
    self.defaultColor = [UIColor lightGrayColor];
    self.shouldAnimateIcons = NO;
    
}

#pragma mark - UIView
- (void)setup {
    
    // Set background color for custom drawing
    self.backgroundColor = [UIColor clearColor];
    
    if (!self.grabberView) {
        self.grabberView = [[GrabberView alloc] initWithFrame:self.bounds];
        [self.contentView insertSubview:self.grabberView atIndex:0];
    }
    
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectInset(self.imageView.frame, 16.0, 16.0);
    self.textLabel.frame = CGRectOffset(self.textLabel.frame, -16.0, 0.0);
    self.detailTextLabel.frame = CGRectOffset(self.detailTextLabel.frame, -16.0, 0.0);
    
}

@end
