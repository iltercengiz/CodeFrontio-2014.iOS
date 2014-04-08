//
//  SessionCell.h
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 08/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Session;

@interface SessionCell : UITableViewCell

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *placeholderImage;
@property (weak, nonatomic) IBOutlet UILabel *speakerNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sessionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionDetailLabel;

@property (weak, nonatomic) IBOutlet UIButton *takeNoteButton;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;

#pragma mark - SessionCell
- (void)configureCellForSession:(Session *)session;

@end
