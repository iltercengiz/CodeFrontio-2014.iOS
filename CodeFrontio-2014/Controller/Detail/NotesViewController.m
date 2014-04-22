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
#import "Photo.h"

#pragma mark View
#import "NoteCell.h"

#pragma mark Controller
#import "NotesViewController.h"
#import "SessionViewController.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <MCSwipeTableViewCell/MCSwipeTableViewCell.h>

#define TAG_SWIPE 1
#define TAG_SELECTED 2

@interface NotesViewController () <UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *notes;
@property (nonatomic) NSIndexPath *removingNoteIndexPath;

@property (nonatomic) UIBarButtonItem *selectAllButton, *deleteButton, *exportButton;

@property (nonatomic, assign) BOOL shouldShowInformation;

@end

@implementation NotesViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Notes", nil);
    
    // Remove title from back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Set toolbar items
    self.selectAllButton = [[UIBarButtonItem alloc] initWithTitle:@"Select All"
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(selectAllTapped:)];
    self.deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                      target:self
                                                                      action:@selector(deleteTapped:)];
    self.exportButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                      target:self
                                                                      action:@selector(exportTapped:)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = @[self.selectAllButton, space, self.deleteButton, space, self.exportButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Get notes
    self.notes = [[Note MR_findAllSortedBy:@"sessionIdentifier" ascending:YES] mutableCopy];
    
    self.shouldShowInformation = self.notes.count == 0 ? YES : NO;
    
    [self.tableView reloadData];
    
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
    
    Note *note = self.notes[indexPath.row];
    NSArray *photos = [Photo MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"sessionIdentifier == %@", note.sessionIdentifier]];
    
    // First delete all photos from disk
    for (Photo *photoEntity in photos) {
        // Get path for the stored photo and remove it
        NSString *photoPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Photo-%@-%@", photoEntity.sessionIdentifier, photoEntity.identifier]];
        [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
    }
    
    // Then delete all photo entities for the related session
    [Photo MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"sessionIdentifier == %@", note.sessionIdentifier]];
    
    // Delete note entity
    [note MR_deleteEntity];
    
    // Save db
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        // if (success) NSLog(@"Save successful!");
        // else NSLog(@"Save failed with error: %@", error);
    }];
    
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
- (IBAction)deleteTapped:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirm deletion", nil)
                                                    message:NSLocalizedString(@"Confirm deletion of notes and photos", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
    alert.tag = TAG_SELECTED;
    [alert show];
}
- (IBAction)exportTapped:(id)sender {
    
    NSMutableArray *notes = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        
        Note *note = self.notes[indexPath.row];
        Session *session = [[Session MR_findByAttribute:@"identifier" withValue:note.sessionIdentifier] firstObject];
        NSArray *photos = [Photo MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"sessionIdentifier == %@", note.sessionIdentifier]];
        
        [notes addObject:[NSString stringWithFormat:@"%@\n\n%@\n\n", session.title, note.note]];
        
        // Get photos related with the note
        for (Photo *photo in photos) {
            NSString *photoPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Photo-%@-%@", photo.sessionIdentifier, photo.identifier]];
            UIImage *photo = [UIImage imageWithContentsOfFile:photoPath];
            [notes addObject:photo];
        }
        
    }
    
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:notes applicationActivities:nil];
    [self.splitViewController presentViewController:activity animated:YES completion:nil];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.notes.count != 0) {
        tableView.scrollEnabled = YES;
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        return self.notes.count;
    } else if ([self shouldShowInformation]) {
        tableView.scrollEnabled = NO;
        self.navigationItem.rightBarButtonItem = nil;
        return 1;
    } else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Note
    Note *note;
    
    @try {
        note = self.notes[indexPath.row];
    } @catch (NSException *exception) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noNotesCell" forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString(@"Notes information", nil);
        return cell;
    }
    
    // Create and configure cell
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notesCell" forIndexPath:indexPath];
    [cell configureCellForNote:note];
    
    // Swipes
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pencil"]]
                            color:[UIColor colorWithRed:0.169 green:0.357 blue:0.616 alpha:1]
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState1
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                      [self startEditingForNoteAtIndexPath:indexPath];
                  }];
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Trash"]]
                            color:[UIColor colorWithRed:0.973 green:0.306 blue:0.306 alpha:1.0]
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState3
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      self.removingNoteIndexPath = [self.tableView indexPathForCell:cell];
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirm deletion", nil)
                                                                      message:NSLocalizedString(@"Confirm deletion of notes and photos", nil)
                                                                     delegate:self
                                                            cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                            otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
                      alert.tag = TAG_SWIPE;
                      [alert show];
                  }];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.notes.count == 0) {
        return CGRectGetHeight(tableView.frame);
    }
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.notes.count == 0) {
        return;
    }
    
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
    
    if (alertView.tag == TAG_SELECTED) {
        if (buttonIndex == 1) {
            
            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
            
            // For every selected row
            for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
                [self removeNoteAtIndexPath:indexPath];
                [indexSet addIndex:indexPath.row];
            }
            
            // Remove the indexPaths from array
            [self.notes removeObjectsAtIndexes:indexSet];
            
            // Update tableView
            [CATransaction begin];
            
            [CATransaction setCompletionBlock:^{
                
                self.editing = NO;
                
                self.shouldShowInformation = self.notes.count == 0 ? YES : NO;
                
                if ([self shouldShowInformation]) {
                    [self.tableView reloadData];
                }
                
            }];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView endUpdates];
            
            [CATransaction commit];
            
            // Enable/Disable buttons
            self.deleteButton.enabled = self.tableView.indexPathsForSelectedRows.count;
            self.exportButton.enabled = self.tableView.indexPathsForSelectedRows.count;
            
        }
    } else { // if (alertView.tag == TAG_SWIPE)
        if (buttonIndex == 1) {
            
            [self removeNoteAtIndexPath:self.removingNoteIndexPath];
            
            // Remove note from array
            [self.notes removeObjectAtIndex:self.removingNoteIndexPath.row];
            
            // Update tableView
            [CATransaction begin];
            
            [CATransaction setCompletionBlock:^{
                
                self.editing = NO;
                
                self.shouldShowInformation = self.notes.count == 0 ? YES : NO;
                
                if ([self shouldShowInformation]) {
                    [self.tableView reloadData];
                }
                
            }];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[self.removingNoteIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView endUpdates];
            
            [CATransaction commit];
            
        } else {
            NoteCell *cell = (NoteCell *)[self.tableView cellForRowAtIndexPath:self.removingNoteIndexPath];
            
            [cell swipeToOriginWithCompletion:^{
                self.removingNoteIndexPath = nil;
            }];
        }
    }
}

@end
