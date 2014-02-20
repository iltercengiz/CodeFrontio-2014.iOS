//
//  PhotosCell.h
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosCell : UITableViewCell

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

#pragma mark - Configurator
- (void)configureCellForSession:(Session *)session andTableView:(UITableView *)tableView;

@end
