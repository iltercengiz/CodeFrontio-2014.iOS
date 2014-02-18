//
//  MenuCell.m
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "MenuCell.h"

@interface MenuCell ()

@end

@implementation MenuCell

#pragma mark - Configurator
- (void)configureCell {
    
    // Set background color for custom drawing
    self.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    // Set text color
    self.textLabel.textColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1];
    
}

#pragma mark - UIView
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath;
    
    // Background
    bezierPath = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor colorWithRed:0.255 green:0.255 blue:0.259 alpha:1] setFill];
    [bezierPath fill];
    
    // Lines
    // Upper line
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath setLineWidth:1.0];
    [bezierPath moveToPoint:(CGPoint){0.0, 1.0}];
    [bezierPath addLineToPoint:(CGPoint){CGRectGetWidth(self.frame), 1.0}];
    [[UIColor colorWithRed:0.325 green:0.325 blue:0.329 alpha:1] setStroke];
    [bezierPath stroke];
    
    // Lower line
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath setLineWidth:1.0];
    [bezierPath moveToPoint:(CGPoint){0.0, CGRectGetHeight(self.frame)}];
    [bezierPath addLineToPoint:(CGPoint){CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)}];
    [[UIColor colorWithRed:0.169 green:0.169 blue:0.173 alpha:1] setStroke];
    [bezierPath stroke];
    
    // Selected indicator
    bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetWidth(rect) - 21.0, 2.0, 20.0, CGRectGetHeight(rect) - 3.0)];
    if (self.selected) {
        [[UIColor colorWithRed:0.965 green:0.620 blue:0.153 alpha:1] setFill];
    } else {
        [[UIColor colorWithRed:0.392 green:0.392 blue:0.400 alpha:1] setFill];
    }
    [bezierPath fill];
    
}

#pragma mark - UITableViewCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Change text color
    if (selected) {
        self.textLabel.textColor = [UIColor colorWithRed:0.965 green:0.620 blue:0.153 alpha:1];
    } else {
        self.textLabel.textColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1];
    }
    
    [self setNeedsDisplay];
}

@end
