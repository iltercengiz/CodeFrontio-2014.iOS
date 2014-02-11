//
//  PhotoCell.m
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

#pragma mark - Configurator
- (void)configureCellForPhoto:(UIImage *)photo {
    
    self.imageView.image = photo;
    
}

@end
