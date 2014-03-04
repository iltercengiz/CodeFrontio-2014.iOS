//
//  GrabberView.m
//  Linz
//
//  Created by Ilter Cengiz on 26/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "GrabberView.h"

@implementation GrabberView

#pragma mark - UIView
- (void)setup {
    
    // Set background color
    self.backgroundColor = [UIColor clearColor];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
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

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat step = 5.0;
    CGFloat offset = 16.0;
    
    // Left grabber
    [path moveToPoint:CGPointMake(step * 1.0, offset)];
    [path addLineToPoint:CGPointMake(step * 1.0, CGRectGetHeight(rect) - offset)];
    [path moveToPoint:CGPointMake(step * 2.0, offset)];
    [path addLineToPoint:CGPointMake(step * 2.0, CGRectGetHeight(rect) - offset)];
//    [path moveToPoint:CGPointMake(step * 3.0, offset)];
//    [path addLineToPoint:CGPointMake(step * 3.0, CGRectGetHeight(rect) - offset)];
    
    // Right grabber
    [path moveToPoint:CGPointMake(CGRectGetWidth(rect) - step * 1.0, offset)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect) - step * 1.0, CGRectGetHeight(rect) - offset)];
    [path moveToPoint:CGPointMake(CGRectGetWidth(rect) - step * 2.0, offset)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect) - step * 2.0, CGRectGetHeight(rect) - offset)];
//    [path moveToPoint:CGPointMake(CGRectGetWidth(rect) - step * 3.0, offset)];
//    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect) - step * 3.0, CGRectGetHeight(rect) - offset)];
    
    path.lineWidth = 0.5;
    [[UIColor lightGrayColor] setStroke];
    [path stroke];
    
}

@end
