//
//  MasterViewController.m
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Categories
#import "UIColor+Palette.h"

#pragma mark Networking
#import "LinzAPIClient.h"

#pragma mark View
#import "MenuCell.h"

#pragma mark Controller
#import "MasterViewController.h"
#import "CalendarViewController.h"
#import "BaseViewController.h"

#pragma mark Constants
#import "Constants.h"

@interface MasterViewController ()

// This will be used to cache the scenes through run time
@property (nonatomic) NSMutableDictionary *scenes;

@end

@implementation MasterViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Prevent tableView from deselecting cells
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Set background color
    self.tableView.backgroundColor = [UIColor colorWithRed:0.255 green:0.255 blue:0.259 alpha:0.0];
    
    // Separator color
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor P_lightBlueColor];
    
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

#pragma mark - Helper
- (void)presentContentWithType:(ContentType)type animated:(BOOL)animated {
    
    if (type == ContentTypeTicket) {
        NSURL *url = [NSURL URLWithString:@"http://codefront2014.eventbrite.com/"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        return;
    } else if (type == ContentTypeTwitter) {
        NSURL *tweetbotAppURL = [NSURL URLWithString:@"tweetbot://codefrontio/user_profile/codefrontio"];
        if ([[UIApplication sharedApplication] canOpenURL:tweetbotAppURL]) {
            [[UIApplication sharedApplication] openURL:tweetbotAppURL];
        }
        NSURL *twitterAppURL = [NSURL URLWithString:@"twitter://user?screen_name=codefrontio"];
        if ([[UIApplication sharedApplication] canOpenURL:twitterAppURL]) {
            [[UIApplication sharedApplication] openURL:twitterAppURL];
        }
        NSURL *url = [NSURL URLWithString:@"http://twitter.com/codefrontio"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        return;
    }
    
    // Set identifier
    NSString *identifier;
    switch (type) {
        case ContentTypeCalendar: identifier = calendarSceneIdentifier; break;
        case ContentTypeFavourites: identifier = favouritesSceneIdentifier; break;
        case ContentTypeNotes: identifier = notesSceneIdentifier; break;
        case ContentTypeNews: identifier = newsSceneIdentifier; break;
        case ContentTypeSponsors: identifier = supportersSceneIdentifier; break;
        default: break;
    }
    
    UIViewController *scene = self.scenes[identifier];
    
    // Check if the scene is available in cache array and if not create and set it
    if (!scene) {
        // Instantiate view controller
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        scene = [[UINavigationController alloc] initWithRootViewController:vc];
        // Add side menu button or dismiss button
        if (type != ContentTypeCalendar && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Dismiss", nil)
                                                                                   style:UIBarButtonItemStyleBordered
                                                                                  target:self
                                                                                  action:@selector(dismiss:)];
        } else { // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Side-menu"]
                                                                                   style:UIBarButtonItemStyleBordered
                                                                                  target:self
                                                                                  action:@selector(toggleSideMenu:)];
        }
        // Add the scene to the cache
        self.scenes[identifier] = scene;
    }
    
    // Present the scene
    
    if (type != ContentTypeCalendar && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        scene.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:scene animated:YES completion:nil];
    } else { // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self.baseViewController setPaneViewController:scene animated:animated completion:nil];
    }
    
}

#pragma mark - IBAction
- (IBAction)toggleSideMenu:(id)sender {
    MSDynamicsDrawerPaneState state = self.baseViewController.paneState == MSDynamicsDrawerPaneStateClosed ? MSDynamicsDrawerPaneStateOpen : MSDynamicsDrawerPaneStateClosed;
    [self.baseViewController setPaneState:state animated:YES allowUserInterruption:YES completion:nil];
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    [cell configureCellForType:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self presentContentWithType:indexPath.row animated:YES];
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
