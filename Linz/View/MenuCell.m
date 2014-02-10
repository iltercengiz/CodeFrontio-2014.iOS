//
//  MenuCell.m
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

#pragma mark - UIView
- (void)drawRect:(CGRect)rect {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    // Upper line
    [bezierPath moveToPoint:(CGPoint){0.0, 0.0}];
    [bezierPath addLineToPoint:(CGPoint){CGRectGetWidth(self.frame), 0.0}];
    
    // Lower line
    [bezierPath moveToPoint:(CGPoint){0.0, CGRectGetHeight(self.frame)}];
    [bezierPath addLineToPoint:(CGPoint){CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)}];
    
    [[UIColor lightGrayColor] setStroke];
    [bezierPath setLineWidth:0.5];
    [bezierPath stroke];
    
}

@end
