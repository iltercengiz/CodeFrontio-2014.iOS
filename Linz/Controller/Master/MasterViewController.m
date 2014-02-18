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

#pragma mark Constants
static const char *calendarSceneIdentifier = "CalendarScene";
static const char *favouritesSceneIdentifier = "FavouritesScene";
static const char *notesSceneIdentifier = "NotesScene";
static const char *venueSceneIdentifier = "VenueScene";
static const char *supportersSceneIdentifier = "SponsorsScene";

@interface MasterViewController ()

// This will be used to cache the scenes through run time
@property (nonatomic) NSMutableArray *scenes;

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
    
    // Select 'Calendar' cell
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
