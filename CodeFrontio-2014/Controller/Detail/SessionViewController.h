//
//  SessionViewController.h
//  Linz
//
//  Created by Ilter Cengiz on 11/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Session;

@interface SessionViewController : UITableViewController

@property (nonatomic) Session *session;
@property (nonatomic, assign, getter = isKeyboardOpen) BOOL keyboardOpen;

@end
