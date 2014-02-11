//
//  CalendarTimeCell.m
//  Linz
//
//  Created by Ilter Cengiz on 11/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "CalendarTimeCell.h"

@implementation CalendarTimeCell

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

@end
