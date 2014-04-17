//
//  SocialCell.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 14/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Speaker.h"

#pragma mark View
#import "SocialCell.h"

@interface SocialCell ()

@end

@implementation SocialCell

#pragma mark - NSObject UIKit Additions
- (void)awakeFromNib {
    
}

#pragma mark - UICollectionViewCell
- (void)prepareForReuse {
    self.imageView.image = nil;
}

#pragma mark - SocialCell
- (void)configureCellForProfileType:(ProfileType)type {
    self.imageView.image = [self imageForProfileType:type];
}

#pragma mark - Helper
- (UIImage *)imageForProfileType:(ProfileType)type {
    switch (type) {
        case Twitter: return [UIImage imageNamed:@"Twitter"];
        case GitHub: return [UIImage imageNamed:@"GitHub"];
        case Dribbble: return [UIImage imageNamed:@"Dribbble"];
        default: return nil;
    }
}

#pragma mark - UIView
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectInset(self.imageView.frame, 12.0, 12.0);
    self.textLabel.frame = CGRectOffset(self.textLabel.frame, -8.0, 0.0);
    
}

@end
