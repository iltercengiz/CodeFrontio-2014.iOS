//
//  MasterViewController.h
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@class BaseViewController;

@interface MasterViewController : UITableViewController

@property (weak, nonatomic) BaseViewController *baseViewController;

- (void)presentContentWithType:(ContentType)type animated:(BOOL)animated;

@end
