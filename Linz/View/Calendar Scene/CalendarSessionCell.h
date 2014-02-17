//
//  CalendarSessionCell.h
//  Linz
//
//  Created by Ilter Cengiz on 11/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Session;

@interface CalendarSessionCell : UICollectionViewCell

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *sessionDetail;

@property (weak, nonatomic) IBOutlet UIButton *takeNoteButton;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;

#pragma mark - CalendarSessionCell
- (void)configureCellForSession:(Session *)session;

@end
