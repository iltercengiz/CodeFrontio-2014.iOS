//
//  NoteCell.m
//  Linz
//
//  Created by Ilter Cengiz on 21/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Note.h"
#import "Session.h"

#pragma mark View
#import "NoteCell.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>

@implementation NoteCell

#pragma mark - Configurator
- (void)configureCellForNote:(Note *)note {
    
    // Cell customization
    self.backgroundColor = [UIColor clearColor];
    
    self.defaultColor = [UIColor lightGrayColor];
    self.shouldAnimateIcons = NO;
    
    // Session
    Session *session = [[Session MR_findByAttribute:@"identifier" withValue:note.sessionIdentifier] firstObject];
    
    // Set title
    NSRange range = [note.note rangeOfString:@"\n"];
    if (range.length) {
        self.textLabel.text = [note.note substringToIndex:range.location];
    } else {
        if (note.note && ![note.note isEqualToString:@""]) {
            self.textLabel.text = note.note;
        } else {
            self.textLabel.text = NSLocalizedString(@"Photos", nil);
        }
    }
    
    // Set subtitle
    self.detailTextLabel.text = session.title;
    
}

#pragma mark - UIView
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectOffset(self.textLabel.frame, 8.0, 0.0);
    self.detailTextLabel.frame = CGRectOffset(self.detailTextLabel.frame, 8.0, 0.0);
    
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
