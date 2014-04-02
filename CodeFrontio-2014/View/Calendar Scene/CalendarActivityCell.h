//
//  CalendarActivityCell.h
//  Linz
//
//  Created by Ilter Cengiz on 17/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Session;

@interface CalendarActivityCell : UICollectionViewCell

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

#pragma mark - CalendarSessionCell
- (void)configureCellForSession:(Session *)session;

@end
