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
#import "BaseViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Prevent tableView from deselecting cells
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Set background color
    self.tableView.backgroundColor = [UIColor colorWithRed:0.255 green:0.255 blue:0.259 alpha:0.0];
    
    // Select 'Calendar' cell
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter
- (NSMutableDictionary *)scenes {
    if (!_scenes) {
        _scenes = [NSMutableDictionary dictionary];
    }
    return _scenes;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    [cell configureCellForType:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set identifier
    NSString *identifier;
    switch (indexPath.row) {
        case ContentTypeCalendar: identifier = calendarSceneIdentifier; break;
        case ContentTypeFavourites: identifier = favouritesSceneIdentifier; break;
        case ContentTypeNotes: identifier = notesSceneIdentifier; break;
        case ContentTypeVenue: identifier = venueSceneIdentifier; break;
        case ContentTypeSponsors: identifier = supportersSceneIdentifier; break;
        default: break;
    }
    
    UIViewController *scene = self.scenes[identifier];
    
    // Check if the scene is available in cache array and if not create and set it
    if (!scene) {
        // Instantiate view controller
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        scene = [[UINavigationController alloc] initWithRootViewController:vc];
        // Add the scene to the cache
        self.scenes[identifier] = scene;
    }
    
    // Present the scene
    [self.baseViewController setPaneViewController:scene animated:YES completion:nil];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [[[NSBundle mainBundle] loadNibNamed:@"SideMenuHeader_iPad" owner:nil options:nil] firstObject];
    } else { // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return [[[NSBundle mainBundle] loadNibNamed:@"SideMenuHeader_iPhone" owner:nil options:nil] firstObject];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 360.0;
    } else { // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return 128.0;
    }
}

@end
