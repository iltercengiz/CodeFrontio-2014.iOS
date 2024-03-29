//
//  SessionViewController.m
//  Linz
//
//  Created by Ilter Cengiz on 11/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Session.h"
#import "Note.h"

#pragma mark View
#import "NotesCell.h"
#import "PhotosCell.h"

#pragma mark Controller
#import "SessionViewController.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>

#define TAG_NOTE 1
#define TAG_PHOTO 2

@interface SessionViewController () <UIAlertViewDelegate, UITextViewDelegate>

@property (nonatomic) Note *note;

@property (nonatomic) NotesCell *notesCell;
@property (nonatomic) PhotosCell *photosCell;

@property (nonatomic) UIBarButtonItem *editButton, *hideKeyboardButton, *doneButton, *deletePhotosButton, *deleteNoteButton;

@property (nonatomic, getter = isTextViewFirstResponder) BOOL textViewIsFirstResponder;

@property (nonatomic) CGFloat notesCellHeight;

@end

@implementation SessionViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Dismiss", nil)
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(dismiss:)];
    }
    
    // Set title
    self.navigationItem.title = self.session.title;
    
    // Edit button for note and photo editing
    self.navigationItem.rightBarButtonItem = self.editButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self saveNoteIfValid];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    
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
                                                                    action:@selector(edit:)];
    }
    return _editButton;
}
- (UIBarButtonItem *)hideKeyboardButton {
    if (!_hideKeyboardButton) {
        _hideKeyboardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Hide-keyboard"]
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(hideKeyboard:)];
    }
    return _hideKeyboardButton;
}
- (UIBarButtonItem *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                    target:self
                                                                    action:@selector(done:)];
    }
    return _doneButton;
}
- (UIBarButtonItem *)deletePhotosButton {
    if (!_deletePhotosButton) {
        _deletePhotosButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Delete photos", nil)
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(deletePhotos:)];
    }
    return _deletePhotosButton;
}
- (UIBarButtonItem *)deleteNoteButton {
    if (!_deleteNoteButton) {
        _deleteNoteButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Delete note", nil)
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(deleteNote:)];
    }
    return _deleteNoteButton;
}

#pragma mark - Helpers
- (void)saveNoteIfValid {
    
    // Check if any note is entered
    // If entered, save it to the Note object
    // Otherwise, remove the Note object from db
    if ([self shouldNoteBeSaved]) {
        self.note.note = self.notesCell.textView.text;
    } else {
        [self.note MR_deleteEntity];
        self.note = nil;
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
- (BOOL)shouldNoteBeSaved {
    if (self.photosCell.photos.count) {
        return YES;
    }
    return [self isNoteValid];
}

#pragma mark - IBAction
- (IBAction)dismiss:(id)sender {
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)edit:(id)sender {
    
    // Set title to nil
    self.navigationItem.title = nil;
    
    // Enable/Disable the button
    self.deletePhotosButton.enabled = self.photosCell.selectedPhotosIndexPaths.count;
    self.deleteNoteButton.enabled = [self isNoteValid];
    
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
- (IBAction)hideKeyboard:(id)sender {
    [self.notesCell.textView resignFirstResponder];
}
- (IBAction)done:(id)sender {
    
    // Set title back
    self.navigationItem.title = self.session.title;
    
    // Change buttons
    self.navigationItem.rightBarButtonItems = @[self.editButton];
    
    // Remove self from notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"io.webBox.KodioLinz.changeInPhotoSelectionNotification"
                                                  object:self.photosCell];
    
    // Set editing
    self.notesCell.editing = NO;
    self.photosCell.editing = NO;
    
}
- (IBAction)deletePhotos:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirm deletion", nil)
                                                    message:NSLocalizedString(@"Confirm deletion message", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
    alert.tag = TAG_PHOTO;
    [alert show];
}
- (IBAction)deleteNote:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirm deletion", nil)
                                                    message:NSLocalizedString(@"Confirm deletion message", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
    alert.tag = TAG_NOTE;
    [alert show];
}

#pragma mark - Notifications
- (void)keyboardWillShow:(NSNotification *)note {
    self.textViewIsFirstResponder = YES;
}
- (void)keyboardWillHide:(NSNotification *)note {
    self.textViewIsFirstResponder = NO;
}

- (void)keyboardDidChangeFrame:(NSNotification *)note {
    
    NSDictionary *userInfo = note.userInfo;
    
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [self.view convertRect:keyboardFrame fromView:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.notesCellHeight = keyboardFrame.origin.y - 86.0; // tableView.sectionHeaderHeight + navigation bar
    } else { // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.notesCellHeight = CGRectGetHeight(self.tableView.frame) - CGRectGetHeight(keyboardFrame) - self.tableView.sectionHeaderHeight;
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        return NSLocalizedString(@"Notes", nil);
    } else {
        return NSLocalizedString(@"Photos", nil);
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        CGFloat height = 0;
        
        if ([self isTextViewFirstResponder])
            height = self.notesCellHeight;
        else
            height = CGRectGetHeight(tableView.frame) - 2.0 * tableView.sectionHeaderHeight - tableView.rowHeight;
        
        return height;
        
    }
    
    return tableView.rowHeight;
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (self.notesCell.editing) {
        return NO;
    }
    
    return YES;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    // Remove/Replace edit item
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    } else { // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self.navigationItem setRightBarButtonItem:self.hideKeyboardButton animated:YES];
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    // Save note
    [self saveNoteIfValid];
    
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
        if (alertView.tag == TAG_NOTE) {
            self.notesCell.textView.text = nil;
            self.deleteNoteButton.enabled = NO;
            [self saveNoteIfValid];
        } else {
            [self.photosCell removeSelectedPhotos];
        }
    }
}

@end
