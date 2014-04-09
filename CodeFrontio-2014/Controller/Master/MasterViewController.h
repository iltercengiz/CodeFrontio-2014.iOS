//
//  MasterViewController.h
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseViewController;

@interface MasterViewController : UITableViewController

@property (weak, nonatomic) BaseViewController *baseViewController;

// This will be used to cache the scenes through run time
@property (nonatomic) NSMutableDictionary *scenes;

@end
