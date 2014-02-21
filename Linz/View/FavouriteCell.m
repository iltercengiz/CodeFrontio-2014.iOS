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

#pragma mark Pods
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <TMCache/TMDiskCache.h>

@implementation FavouriteCell

#pragma mark - Configurator
- (void)configureCellForSession:(Session *)session {
    
    // Cell customization
    self.backgroundColor = [UIColor clearColor];
    
    self.defaultColor = [UIColor lightGrayColor];
    self.shouldAnimateIcons = NO;
    
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
                                           NSLog(@"Error getting image: %@", error.description);
                                       }];
    }
    
    // Set title
    self.textLabel.text = session.title;
    
    // Set subtitle
    self.detailTextLabel.text = speaker.name;
    
}

#pragma mark - UIView
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectInset(self.imageView.frame, 16.0, 16.0);
    self.textLabel.frame = CGRectOffset(self.textLabel.frame, -16.0, 0.0);
    self.detailTextLabel.frame = CGRectOffset(self.detailTextLabel.frame, -16.0, 0.0);
    
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat step = 5.0;
    CGFloat offset = 16.0;
    
    // Left grabber
    [path moveToPoint:CGPointMake(step * 1.0, offset)];
    [path addLineToPoint:CGPointMake(step * 1.0, CGRectGetHeight(rect) - offset)];
    [path moveToPoint:CGPointMake(step * 2.0, offset)];
    [path addLineToPoint:CGPointMake(step * 2.0, CGRectGetHeight(rect) - offset)];
    [path moveToPoint:CGPointMake(step * 3.0, offset)];
    [path addLineToPoint:CGPointMake(step * 3.0, CGRectGetHeight(rect) - offset)];
    
    // Right grabber
    [path moveToPoint:CGPointMake(CGRectGetWidth(rect) - step * 1.0, offset)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect) - step * 1.0, CGRectGetHeight(rect) - offset)];
    [path moveToPoint:CGPointMake(CGRectGetWidth(rect) - step * 2.0, offset)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect) - step * 2.0, CGRectGetHeight(rect) - offset)];
    [path moveToPoint:CGPointMake(CGRectGetWidth(rect) - step * 3.0, offset)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect) - step * 3.0, CGRectGetHeight(rect) - offset)];
    
    path.lineWidth = 0.5;
    [[UIColor lightGrayColor] setStroke];
    [path stroke];
    
}

@end
