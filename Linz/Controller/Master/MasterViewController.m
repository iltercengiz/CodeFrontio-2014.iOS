//
//  MasterViewController.m
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Networking
#import "LinzAPIClient.h"

#pragma mark View
#import "MenuCell.h"

#pragma mark Controller
#import "MasterViewController.h"
#import "CalendarViewController.h"

#pragma mark Pods
#import <SVProgressHUD/SVProgressHUD.h>

#pragma mark Constants
static const char *calendarSceneIdentifier = "CalendarScene";
static const char *favouritesSceneIdentifier = "FavouritesScene";
static const char *notesSceneIdentifier = "NotesScene";
static const char *venueSceneIdentifier = "VenueScene";
static const char *supportersSceneIdentifier = "SponsorsScene";

@interface MasterViewController ()

// This will be used to cache the scenes through run time
@property (nonatomic) NSMutableArray *scenes;

@property (nonatomic, getter = isSetupDone) BOOL setupDone;

@end

@implementation MasterViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Prevent tableView from deselecting cells
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Create the scenes array with NSNulls
    self.scenes = [NSMutableArray arrayWithObjects:[NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], nil];
    
    // Add calendar scene to the cache array
    UINavigationController *navigationController = [self.splitViewController.viewControllers lastObject];
    UIViewController *calendarViewController = navigationController.topViewController;
    [self.scenes replaceObjectAtIndex:0 withObject:calendarViewController];
    
    // Set background color
    self.tableView.backgroundColor = [UIColor colorWithRed:0.255 green:0.255 blue:0.259 alpha:1];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Show progress hud
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    __block NSArray *speakers;
    __block NSArray *sessions;
    
    void (^proceedBlock)() = ^{
        
        if (!speakers || !sessions) {
            return;
        }
        
        self.setupDone = YES;
        
        // Reload tableView
        [self.tableView reloadData];
        
        // Select 'Calendar' cell
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
        
        UISplitViewController *svc = self.splitViewController;
        UINavigationController *nvc = [svc.viewControllers lastObject];
        CalendarViewController *cvc = [nvc.viewControllers firstObject];
        
        cvc.speakers = speakers;
        cvc.sessions = sessions;
        
        [cvc reloadCalendar];
        
        // Dismiss progress hud
        [SVProgressHUD showSuccessWithStatus:nil];
        
    };
    
    [[LinzAPIClient sharedClient] GET:@"/speakers"
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  speakers = responseObject;
                                  proceedBlock();
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  NSLog(@"Error: %@", error.description);
                              }];
    
    [[LinzAPIClient sharedClient] GET:@"/sessions"
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  
                                  // Loop through the sessions and add timeCell datas to the appropriate indexes
                                  NSArray *immutableSessions = responseObject;
                                  NSMutableArray *mutableSessions = [NSMutableArray array];
                                  for (NSDictionary *session in immutableSessions) {
                                      // Add a small dictionary object to specify time cells
                                      // Check type and track values of the sessions for appropriate placing
                                      if ([session[@"type"] isEqualToNumber:@0] ||
                                          [session[@"track"] isEqualToNumber:@1]) // We check the track info instead of type to not to add time data twice for simultaneous sessions
                                      {
                                          [mutableSessions addObject:@{@"track": @0, @"type": @(-1)}];
                                      }
                                      // Add the session to array
                                      [mutableSessions addObject:session];
                                  }
                                  
                                  sessions = mutableSessions;
                                  proceedBlock();
                                  
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  NSLog(@"Error: %@", error.description);
                              }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self isSetupDone]) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    [cell configureCell];
    
    // Set title
    switch (indexPath.row) {
        case 0: cell.textLabel.text = NSLocalizedString(@"Calendar", nil); break;
        case 1: cell.textLabel.text = NSLocalizedString(@"Favourites", nil); break;
        case 2: cell.textLabel.text = NSLocalizedString(@"Notes", nil); break;
        case 3: cell.textLabel.text = NSLocalizedString(@"Venue", nil); break;
        case 4: cell.textLabel.text = NSLocalizedString(@"Supporters", nil); break;
        default: break;
    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *scene;
    
    // Check if the scene is available in cache array
    id object = self.scenes[indexPath.row];
    if (![object isEqual:[NSNull null]]) {
        scene = object;
    } else {
        
        // Set identifier
        NSString *identifier;
        switch (indexPath.row) {
            case 0: identifier = [NSString stringWithUTF8String:calendarSceneIdentifier]; break;
            case 1: identifier = [NSString stringWithUTF8String:favouritesSceneIdentifier]; break;
            case 2: identifier = [NSString stringWithUTF8String:notesSceneIdentifier]; break;
            case 3: identifier = [NSString stringWithUTF8String:venueSceneIdentifier]; break;
            case 4: identifier = [NSString stringWithUTF8String:supportersSceneIdentifier]; break;
            default: break;
        }
        
        // Instantiate view controller
        scene = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
        // Add the scene to the cache
        [self.scenes replaceObjectAtIndex:indexPath.row withObject:scene];
        
    }
    
    // Present the scene
    UINavigationController *navigationController = [self.splitViewController.viewControllers lastObject];
    navigationController.viewControllers = @[scene];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"MasterViewHeader" owner:self options:nil] firstObject];
    return headerView;
}

@end
