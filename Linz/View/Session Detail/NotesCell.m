//
//  NotesCell.m
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Note.h"

#pragma mark View
#import "NotesCell.h"

@interface NotesCell ()

@property (nonatomic) Note *note;

@end

@implementation NotesCell

#pragma mark - Configurator
- (void)configureCellForNote:(Note *)note {
    
    // Assign the note object
    self.note = note;
    
    // Set the note
    if (note.note) {
        self.textView.text = note.note;
    }
    
}

@end
