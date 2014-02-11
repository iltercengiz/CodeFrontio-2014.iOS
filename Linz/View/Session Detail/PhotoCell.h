//
//  PhotoCell.h
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

#pragma mark - Configurator
- (void)configureCellForPhoto:(UIImage *)photo;

@end
