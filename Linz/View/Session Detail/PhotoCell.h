//
//  PhotoCell.h
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface PhotoCell : UICollectionViewCell

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

#pragma mark - Properties
@property (nonatomic, getter = isMarked) BOOL marked;

#pragma mark - Configurator
- (void)configureCellForPhoto:(Photo *)photoEntity;

@end
