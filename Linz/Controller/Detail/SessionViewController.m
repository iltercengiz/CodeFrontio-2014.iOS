//
//  SessionViewController.m
//  Linz
//
//  Created by Ilter Cengiz on 11/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Session.h"
#import "Speaker.h"
#import "Note.h"

#pragma mark View
#import "SpeakerCell.h"
#import "NotesCell.h"
#import "PhotosCell.h"

#pragma mark Controller
#import "SessionViewController.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface SessionViewController () <UIAlertViewDelegate, UITextViewDelegate>

@property (nonatomic) Note *note;

@property (nonatomic) NotesCell *notesCell;
@property (nonatomic) PhotosCell *photosCell;

@property (nonatomic) UIBarButtonItem *editButton, *doneButton, *deletePhotosButton, *deleteNoteButton;

@property (nonatomic, getter = willTextViewBeFirstResponder) BOOL textViewWillBeFirstResponder;

@end

@implementation SessionViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Set title
    self.navigationItem.title = self.session.title;
    
    // Edit button for note and photo editing
    self.navigationItem.rightBarButtonItem = self.editButton;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self saveNoteIfValid];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter
- (Note *)note {
    if (!_note) {
        // Try to get the Note object, if there is any, associated with this session
        _note = [[Note MR_findByAttribute:@"sessionIdentifier" withValue:self.session.identifier] firstObject];
        // If there isn't any Note object in db, create one
        if (!_note) {
            // Create entity
            _note = [Note MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
            _note.sessionIdentifier = self.session.identifier;
            // Save it to the db
            [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                // if (success) NSLog(@"Save successful!");
                // else NSLog(@"Save failed with error: %@", error);
            }];
        }
    }
    return _note;
}

- (UIBarButtonItem *)editButton {
    if (!_editButton) {
        _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                    target:self
                                                                    action:@selector(editTapped:)];
    }
    return _editButton;
}
- (UIBarButtonItem *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                    target:self
                                                                    action:@selector(doneTapped:)];
    }
    return _doneButton;
}
- (UIBarButtonItem *)deletePhotosButton {
    if (!_deletePhotosButton) {
        _deletePhotosButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Delete photos", nil)
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(deletePhotosTapped:)];
    }
    return _deletePhotosButton;
}
- (UIBarButtonItem *)deleteNoteButton {
    if (!_deleteNoteButton) {
        _deleteNoteButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Delete note", nil)
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(deleteNoteTapped:)];
    }
    return _deleteNoteButton;
}

#pragma mark - Helpers
- (void)saveNoteIfValid {
    
    // Check if any note is entered
    // If entered, save it to the Note object
    // Otherwise, remove the Note object from db
    if ([self isNoteValid]) {
        self.note.note = self.notesCell.textView.text;
    } else {
        [self.note MR_deleteEntity];
    }
    
    // Save db
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        // if (success) NSLog(@"Save successful!");
        // else NSLog(@"Save failed with error: %@", error);
    }];
    
}
- (BOOL)isNoteValid {
    NSString *trimmedNote = [self.notesCell.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // To prevent whitespace only notes
    return ![self.notesCell.textView.text isEqualToString:@""] && trimmedNote && ![trimmedNote isEqualToString:@""];
}

#pragma mark - IBAction
- (IBAction)editTapped:(id)sender {
    
    // Set title to nil
    self.navigationItem.title = nil;
    
    // Enable/Disable the button
    if (!self.photosCell.selectedPhotosIndexPaths.count) {
        self.deletePhotosButton.enabled = NO;
    }
    if (![self isNoteValid]) {
        self.deleteNoteButton.enabled = NO;
    }
    
    // Set buttons
    self.navigationItem.rightBarButtonItems = @[self.doneButton, self.deletePhotosButton, self.deleteNoteButton];
    
    // Set self as observer for changeInPhotoSelectionNotification
    [[NSNotificationCenter defaultCenter] addObserverForName:@"io.webBox.KodioLinz.changeInPhotoSelectionNotification"
                                                      object:self.photosCell
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      if (!self.photosCell.selectedPhotosIndexPaths.count) {
                                                          self.deletePhotosButton.enabled = NO;
                                                      } else {
                                                          self.deletePhotosButton.enabled = YES;
                                                      }
                                                  }];
    
    // Set editing
    self.notesCell.editing = YES;
    self.photosCell.editing = YES;
    
}
- (IBAction)deleteNoteTapped:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirm deletion", nil)
                                                    message:NSLocalizedString(@"Confirm deletion message", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
    [alert show];
}
- (IBAction)deletePhotosTapped:(id)sender {
    [self.photosCell removeSelectedPhotos];
}
- (IBAction)doneTapped:(id)sender {
    
    // Set title back
    self.navigationItem.title = self.session.title;
    
    // Change buttons
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                              target:self
                                                                                              action:@selector(editTapped:)]];
    
    // Remove self from notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"io.webBox.KodioLinz.changeInPhotoSelectionNotification"
                                                  object:self.photosCell];
    
    // Set editing
    self.notesCell.editing = NO;
    self.photosCell.editing = NO;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SpeakerCell *(^createSpeakerCell)() = ^SpeakerCell *(){
        SpeakerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"speakerCell" forIndexPath:indexPath];
        Speaker *speaker = [[Speaker MR_findByAttribute:@"identifier" withValue:self.session.speakerIdentifier] firstObject]; // Speaker of the session
        [cell configureCellForSpeaker:speaker];
        return cell;
    };
    
    NotesCell *(^createNotesCell)() = ^NotesCell *(){
        NotesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notesCell" forIndexPath:indexPath];
        [cell configureCellForNote:self.note];
        cell.textView.delegate = self;
        return cell;
    };
    
    PhotosCell *(^createPhotosCell)() = ^PhotosCell *(){
        PhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photosCell" forIndexPath:indexPath];
        [cell configureCellForSession:self.session andTableView:tableView];
        return cell;
    };
    
    if (indexPath.section == 0) {
        return createSpeakerCell();
    } else if (indexPath.section == 1) {
        self.notesCell = createNotesCell();
        return self.notesCell;
    } else {
        self.photosCell = createPhotosCell();
        return self.photosCell;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Return the appropriate title
    if (section == 0) {
        return NSLocalizedString(@"Speaker", nil);
    } else if (section == 1) {
        return NSLocalizedString(@"Notes", nil);
    } else {
        return NSLocalizedString(@"Photos", nil);
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if ([self willTextViewBeFirstResponder]) {
            return CGRectGetHeight(tableView.frame) - 1.0 * tableView.sectionHeaderHeight - 352.0;
        }
        return CGRectGetHeight(tableView.frame) - 3.0 * tableView.sectionHeaderHeight - tableView.rowHeight - 144.0;
    } else if (indexPath.section == 2) {
        return 144.0;
    }
    return tableView.rowHeight;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (self.notesCell.editing) {
        return NO;
    }
    
    // Update notes cell
    self.textViewWillBeFirstResponder = YES;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    return YES;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    // Remove edit item
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    
    // Scroll table view
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    // Save note
    [self saveNoteIfValid];
    
    // Update notes cell
    self.textViewWillBeFirstResponder = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    // Place the edit button back
    [self.navigationItem setRightBarButtonItem:self.editButton animated:YES];
    
}

// Thanks to @davidisdk for this great answer: http://stackoverflow.com/a/19276988/1931781
// Makes the scroll follow caret
- (void)textViewDidChange:(UITextView *)textView {
    CGRect line = [textView caretRectForPosition:textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height - (textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top);
    if (overflow > 0) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:0.3 animations:^{
            [textView setContentOffset:offset];
        }];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        self.notesCell.textView.text = nil;
        [self saveNoteIfValid];
    }
}

@end
