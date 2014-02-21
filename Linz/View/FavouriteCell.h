//
//  FavouriteCell.h
//  Linz
//
//  Created by Ilter Cengiz on 21/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MCSwipeTableViewCell/MCSwipeTableViewCell.h>

@class Session;

@interface FavouriteCell : MCSwipeTableViewCell

#pragma mark - Configurator
- (void)configureCellForSession:(Session *)session;

@end
