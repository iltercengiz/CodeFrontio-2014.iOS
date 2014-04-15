//
//  SocialCell.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 14/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "SocialCell.h"

@implementation SocialCell

#pragma mark - UICollectionViewCell
- (void)prepareForReuse {
    self.imageView.image = nil;
}

#pragma mark - SocialCell
- (void)configureCellForProfileType:(ProfileType)type {
    switch (type) {
        case Twitter:
            self.imageView.image = [UIImage imageNamed:@"Twitter"];
            break;
        case GitHub:
            self.imageView.image = [UIImage imageNamed:@"GitHub"];
            break;
        case Dribbble:
            self.imageView.image = [UIImage imageNamed:@"Dribbble"];
            break;
        default:
            break;
    }
}

@end
