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

#pragma mark - NotesCell
- (void)setup {
    
    // Set background image
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Paper"]];
    
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

@end
