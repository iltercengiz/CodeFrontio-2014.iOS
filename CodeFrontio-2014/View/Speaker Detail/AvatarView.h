//
//  AvatarView.h
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 14/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Speaker;

@interface AvatarView : UICollectionReusableView

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

#pragma mark - AvatarView
- (void)configureViewForSpeaker:(Speaker *)speaker;

@end
