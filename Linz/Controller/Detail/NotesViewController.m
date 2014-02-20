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

#pragma mark Controller
#import "NotesViewController.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface NotesViewController ()

@property (nonatomic) NSMutableArray *notes;

@end

@implementation NotesViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notesCell" forIndexPath:indexPath];
    
    // Note & Session
    Note *note = self.notes[indexPath.row];
    Session *session = [[Session MR_findByAttribute:@"identifier" withValue:note.sessionIdentifier] firstObject];
    
    // Set title
    NSRange range = [note.note rangeOfString:@"\n"];
    if (range.length) {
        cell.textLabel.text = [note.note substringToIndex:range.location];
    } else {
        cell.textLabel.text = note.note;
    }
    
    // Set subtitle
    cell.detailTextLabel.text = session.title;
    
    return cell;
}

@end
