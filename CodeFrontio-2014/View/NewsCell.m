//
//  NewsCell.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 17/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

#pragma mark - NSObject UIKit Additions
- (void)awakeFromNib {
    
    self.textView.scrollsToTop = NO;
    self.textView.scrollEnabled = NO;
//    self.textView.contentInset = UIEdgeInsetsMake(-8.0, 0.0, 0.0, 0.0); // top, left, bottom, right
    self.textView.textContainerInset = UIEdgeInsetsMake(0.0, 0.0, -10.0, 0.0);
    
    self.detailLabel.clipsToBounds = NO;
    
}

@end
