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

@end

@implementation SessionViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Set title
    self.title = self.session.title;
    
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
        NSArray *photos = @[[UIImage imageNamed:@"kod-io-logo-black"],
                            [UIImage imageNamed:@"kod-io-logo-black"] ];
        [cell configureCellForTableView:tableView withPhotos:photos];
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
        
        // If there is any saved note, calculate its text size
        if (self.note) {
            
            CGSize size = [self.note.note boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.frame) - 20.0, CGFLOAT_MAX)
                                                       options:0
                                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
                                                       context:nil].size;
            
            if (size.height > 144.0) {
                return size.height;
            }
            
        }
        
        return 144.0;
        
    } else if (indexPath.section == 2) {
        return 144.0;
    } else {
        return tableView.rowHeight;
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    // Check if any note is entered
    // If entered, save it to the Note object
    // Otherwise, remove the Note object from db
    if (![self.noteView.text isEqualToString:@""]) {
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

@end
