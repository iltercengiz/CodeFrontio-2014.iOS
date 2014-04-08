//
//  SideMenuHeader.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 08/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Categories
#import "UIColor+Palette.h"

#pragma mark View
#import "SideMenuHeader.h"

@implementation SideMenuHeader

- (void)awakeFromNib {
    self.backgroundColor = [UIColor P_blueishWhiteColor];
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, CGRectGetHeight(rect))];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [[UIColor P_lightBlueColor] setStroke];
    [path setLineWidth:1.0];
    [path stroke];
    
}

- (IBAction)codefrontioIsPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://codefront.io"]];
}
- (IBAction)webboxIsPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://webbox.io"]];
}

@end
