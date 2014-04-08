//
//  MasterViewController.h
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark Constants
static NSString * const calendarSceneIdentifier = @"CalendarScene";
static NSString * const favouritesSceneIdentifier = @"FavouritesScene";
static NSString * const notesSceneIdentifier = @"NotesScene";
static NSString * const supportersSceneIdentifier = @"SponsorsScene";

@class BaseViewController;

@interface MasterViewController : UITableViewController

@property (weak, nonatomic) BaseViewController *baseViewController;

// This will be used to cache the scenes through run time
@property (nonatomic) NSMutableDictionary *scenes;

@end
