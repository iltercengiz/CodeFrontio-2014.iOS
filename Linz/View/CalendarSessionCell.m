//
//  CalendarSessionCell.m
//  Linz
//
//  Created by Ilter Cengiz on 11/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark View
#import "CalendarSessionCell.h"

#pragma mark Constants
static const CGFloat cornerRadius = 4.0;
static const CGFloat borderWidth = 1.0;

@implementation CalendarSessionCell

#pragma mark - UIView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    path.lineWidth = 0.5;
    
    [[UIColor lightGrayColor] setStroke];
    [path stroke];
    
}

#pragma mark - CalendarSessionCell
- (void)configureCellForSession:(NSDictionary *)session {
    
    self.takeNoteButton.layer.cornerRadius = cornerRadius;
    self.takeNoteButton.layer.borderColor = [UIColor colorWithWhite:34.0/255.0 alpha:1.0].CGColor;
    self.takeNoteButton.layer.borderWidth = borderWidth;
    
    self.favouriteButton.layer.cornerRadius = cornerRadius;
    self.favouriteButton.layer.borderColor = [UIColor colorWithWhite:34.0/255.0 alpha:1.0].CGColor;
    self.favouriteButton.layer.borderWidth = borderWidth;
    
}

@end
