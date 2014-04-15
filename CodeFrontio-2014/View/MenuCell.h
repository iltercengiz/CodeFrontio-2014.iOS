//
//  MenuCell.h
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@interface MenuCell : UITableViewCell

#pragma mark - Configurator
- (void)configureCellForType:(ContentType)contentType;

@end
