//
//  CalendarTimeCell.m
//  Linz
//
//  Created by Ilter Cengiz on 11/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "CalendarTimeCell.h"

@implementation CalendarTimeCell

#pragma mark - Configurator
- (void)configureCellForTimeInterval:(NSTimeInterval)timeInterval {
    
    // Set background color for custom drawing
    self.backgroundColor = [UIColor clearColor];
    
    // Set text color
    self.timeLabel.textColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1];
    
}

#pragma mark - UIView
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path;
    
    // Background
    path = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor colorWithRed:0.153 green:0.153 blue:0.157 alpha:1] setFill];
    [path fill];
    
    // Frame line
    path = [UIBezierPath bezierPathWithRect:rect];
    path.lineWidth = 1.0;
    [[UIColor colorWithRed:0.278 green:0.278 blue:0.282 alpha:1] setStroke];
    [path stroke];
    
}

@end
