//
//  NotesViewController.m
//  Linz
//
//  Created by Ilter Cengiz on 18/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Note.h"
#import "Session.h"

#pragma mark View
#import "NoteCell.h"

#pragma mark Controller
#import "NotesViewController.h"
#import "SessionViewController.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <MCSwipeTableViewCell/MCSwipeTableViewCell.h>

@interface NotesViewController () <UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *notes;
@property (nonatomic) NSIndexPath *removingNoteIndexPath;

@property (nonatomic) UIBarButtonItem *selectAllButton, *deleteButton, *exportButton;

@end

@implementation NotesViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Edit button
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Set toolbar items
    self.selectAllButton = [[UIBarButtonItem alloc] initWithTitle:@"Select All"
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(selectAllTapped:)];
    self.deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                      target:self
                                                                      action:@selector(nilSymbol)];
    self.exportButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                      target:self
                                                                      action:@selector(nilSymbol)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = @[self.selectAllButton, space, self.deleteButton, space, self.exportButton];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Get notes
    self.notes = [[Note MR_findAllSortedBy:@"sessionIdentifier" ascending:YES] mutableCopy];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sessionSegue"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        Note *note = self.notes[indexPath.row];
        Session *session = [[Session MR_findByAttribute:@"identifier" withValue:note.sessionIdentifier] firstObject];
        SessionViewController *svc = segue.destinationViewController;
        svc.session = session;
    }
}

#pragma mark - Setter
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    // Disable deleteButton and exportButton as initially no cells will be selected
    self.deleteButton.enabled = NO;
    self.exportButton.enabled = NO;
    
    [self.navigationController setToolbarHidden:!editing animated:animated];
    
}

#pragma mark - Helpers
- (void)startEditingForNoteAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"sessionSegue" sender:indexPath];
}
- (void)removeNoteAtIndexPath:(NSIndexPath *)indexPath {
    
    self.removingNoteIndexPath = indexPath;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirm deletion", nil)
                                                    message:NSLocalizedString(@"Confirm deletion message", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
    [alert show];
}

#pragma mark - IBActions
- (IBAction)selectAllTapped:(id)sender {
    
    // De/Select all cells
    if ([self.selectAllButton.title isEqualToString:@"Select All"]) {
        for (NSInteger i = 0; i < self.notes.count; i++) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        self.selectAllButton.title = @"Deselect All";
    } else {
        for (NSInteger i = 0; i < self.notes.count; i++) {
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO];
        }
        self.selectAllButton.title = @"Select All";
    }
    
    // Enable/Disable buttons
    self.deleteButton.enabled = self.tableView.indexPathsForSelectedRows.count;
    self.exportButton.enabled = self.tableView.indexPathsForSelectedRows.count;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Note
    Note *note = self.notes[indexPath.row];
    
    // Create and configure cell
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notesCell" forIndexPath:indexPath];
    [cell configureCellForNote:note];
    
    // Swipes
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar-note"]]
                            color:[UIColor colorWithRed:0.169 green:0.357 blue:0.616 alpha:1]
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState1
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                      [self startEditingForNoteAtIndexPath:indexPath];
                  }];
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trash-bin"]]
                            color:[UIColor colorWithRed:0.973 green:0.306 blue:0.306 alpha:1.0]
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState3
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                      [self removeNoteAtIndexPath:indexPath];
                  }];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // If tableView is not in editing mode, push Session scene
    if (!self.editing) {
        [self startEditingForNoteAtIndexPath:indexPath];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        // Enable/Disable buttons
        self.deleteButton.enabled = self.tableView.indexPathsForSelectedRows.count;
        self.exportButton.enabled = self.tableView.indexPathsForSelectedRows.count;
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Update buttons
    if (self.editing) {
        // Enable/Disable buttons
        self.deleteButton.enabled = self.tableView.indexPathsForSelectedRows.count;
        self.exportButton.enabled = self.tableView.indexPathsForSelectedRows.count;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        Note *note = self.notes[self.removingNoteIndexPath.row];
        
        [note MR_deleteEntity];
        
        // Save db
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            // if (success) NSLog(@"Save successful!");
            // else NSLog(@"Save failed with error: %@", error);
        }];
        
        // Remove note from array
        [self.notes removeObjectAtIndex:self.removingNoteIndexPath.row];
        
        // Update tableView
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[self.removingNoteIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        
    } else {
        
        NoteCell *cell = (NoteCell *)[self.tableView cellForRowAtIndexPath:self.removingNoteIndexPath];
        
        [cell swipeToOriginWithCompletion:^{
            self.removingNoteIndexPath = nil;
        }];
        
    }
    
}

@end
