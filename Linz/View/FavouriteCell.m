//
//  FavouriteCell.m
//  Linz
//
//  Created by Ilter Cengiz on 21/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "FavouriteCell.h"

@implementation FavouriteCell

#pragma mark - UIView
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectInset(self.imageView.frame, 4.0, 4.0);
    
}

@end
