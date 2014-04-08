//
//  TrackCell.h
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 06/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *sessions;

@end
