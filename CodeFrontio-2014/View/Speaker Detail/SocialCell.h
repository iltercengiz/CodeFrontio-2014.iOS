//
//  SocialCell.h
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 14/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ProfileType) {
    Twitter,
    GitHub,
    Dribbble
};

@class Speaker;

@interface SocialCell : UICollectionViewCell

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

#pragma mark - SocialCell
- (void)configureCellForProfileType:(ProfileType)type;

@end
