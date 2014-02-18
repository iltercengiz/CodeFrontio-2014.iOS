//
//  UIImage+FromUIColor.m
//  Linz
//
//  Created by Ilter Cengiz on 14/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "UIImage+FromUIColor.h"

@implementation UIImage (FromUIColor)

+ (UIImage *)imageWithUIColor:(UIColor *)color {
    
    UIImage *image = ({
        CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image;
    });
    
    return image;
    
}

@end
