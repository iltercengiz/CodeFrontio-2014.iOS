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

@interface SessionViewController () <UITextViewDelegate>

@property (nonatomic) Note *note;
@property (nonatomic) UITextView *noteView;

@property (nonatomic) CGFloat notesCellRowHeight;

@property (nonatomic) CGFloat keyboardHeight;

@end

@implementation SessionViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Set title
    self.title = self.session.title;
    
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
                if (success) NSLog(@"Save successful!");
                else NSLog(@"Save failed with error: %@", error);
            }];
        }
    }
    return _note;
}

#pragma mark - Helpers
- (void)saveNoteIfValid {
    
    // Check if any note is entered
    // If entered, save it to the Note object
    // Otherwise, remove the Note object from db
    NSString *trimmedNote = [self.noteView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // To prevent whitespace only notes
    
    if (![self.noteView.text isEqualToString:@""] && trimmedNote && ![trimmedNote isEqualToString:@""]) {
        self.note.note = self.noteView.text;
    } else {
        [self.note MR_deleteEntity];
    }
    
    // Save db
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) NSLog(@"Save successful!");
        else NSLog(@"Save failed with error: %@", error);
    }];
    
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
        self.noteView = cell.textView;
        self.noteView.delegate = self;
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
        return createNotesCell();
    } else {
        return createPhotosCell();
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
        return 256.0;
    } else if (indexPath.section == 2) {
        return 144.0;
    }
    return tableView.rowHeight;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self saveNoteIfValid];
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

@end
