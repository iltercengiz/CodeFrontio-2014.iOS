//
//  SessionCellDouble.h
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 15/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Session;

@interface SessionCellDouble : UITableViewCell

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstPlaceholderImage;
@property (weak, nonatomic) IBOutlet UILabel *firstSpeakerNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *secondPlaceholderImage;
@property (weak, nonatomic) IBOutlet UILabel *secondSpeakerNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sessionDetailLabel;

@property (weak, nonatomic) IBOutlet UIButton *takeNoteButton;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;

#pragma mark - SessionCellDouble
- (void)configureCellForSession:(Session *)session;

@end
