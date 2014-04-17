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

@interface SocialCell : UITableViewCell

//#pragma mark - IBOutlets
//@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

#pragma mark - Properties
@property (nonatomic) Speaker *speaker;

#pragma mark - SocialCell
//- (void)configureCellForSpeaker:(Speaker *)speaker;
- (void)configureCellForProfileType:(ProfileType)type;

@end
