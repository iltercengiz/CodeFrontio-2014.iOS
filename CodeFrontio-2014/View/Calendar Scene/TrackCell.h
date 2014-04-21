//
//  TrackCell.h
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 06/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TrackCellDelegate;

@interface TrackCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *trackLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) id<TrackCellDelegate> trackCellDelegate;

- (void)configureCellForSessions:(NSArray *)sessions offset:(NSValue *)offsetValue;

@end

@protocol TrackCellDelegate <NSObject>

- (void)trackTableView:(NSNumber *)trackNumber didScroll:(CGPoint)offset;

@end
