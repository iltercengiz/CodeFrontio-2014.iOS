//
//  FavouritesViewController.m
//  Linz
//
//  Created by Ilter Cengiz on 18/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Manager
#import "Manager.h"

#pragma mark Model
#import "Session.h"

#pragma mark View
#import "FavouriteCell.h"

#pragma mark Controller
#import "FavouritesViewController.h"
#import "SessionViewController.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <MCSwipeTableViewCell/MCSwipeTableViewCell.h>

@interface FavouritesViewController ()

@property (nonatomic) NSMutableArray *sessions;

@end

@implementation FavouritesViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Get sessions
    NSArray *sessions;
    sessions = [Manager sharedManager].sessions;
    sessions = [sessions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"favourited == %@", @YES]];
    self.sessions = [sessions mutableCopy];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sessionSegue"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        Session *session = self.sessions[indexPath.row];
        SessionViewController *svc = segue.destinationViewController;
        svc.session = session;
    }
}

#pragma mark - Helpers
- (void)takeNoteForSessionAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"sessionSegue" sender:indexPath];
}
- (void)removeSessionAtIndexPath:(NSIndexPath *)indexPath {
    
    // Session at indexPath
    Session *session = self.sessions[indexPath.row];
    session.favourited = @NO;
    
    // Save db
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        // if (success) NSLog(@"Save successful!");
        // else NSLog(@"Save failed with error: %@", error);
    }];
    
    // Remove session from array
    [self.sessions removeObjectAtIndex:indexPath.row];
    
    // Update tableView
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sessions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Session
    Session *session = self.sessions[indexPath.row];
    
    // Create and configure cell
    FavouriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell" forIndexPath:indexPath];
    [cell configureCellForSession:session];
    
    // Swipes
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar-note"]]
                            color:[UIColor colorWithRed:0.169 green:0.357 blue:0.616 alpha:1]
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState1
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                      [self takeNoteForSessionAtIndexPath:indexPath];
                  }];
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar-favourite-selected"]]
                            color:[UIColor colorWithRed:0.973 green:0.306 blue:0.306 alpha:1.0]
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState3
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                      [self removeSessionAtIndexPath:indexPath];
                  }];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self takeNoteForSessionAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
