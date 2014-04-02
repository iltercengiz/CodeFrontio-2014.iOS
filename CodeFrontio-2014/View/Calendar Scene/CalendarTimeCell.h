//
//  CalendarTimeCell.h
//  Linz
//
//  Created by Ilter Cengiz on 11/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Session;

@interface CalendarTimeCell : UICollectionViewCell

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

#pragma mark - Configurator
- (void)configureCellForSession:(Session *)session;

@end
