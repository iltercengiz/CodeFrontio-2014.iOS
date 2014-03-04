//
//  NoteCell.m
//  Linz
//
//  Created by Ilter Cengiz on 21/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Note.h"
#import "Session.h"

#pragma mark View
#import "NoteCell.h"
#import "GrabberView.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface NoteCell ()

@property (nonatomic) GrabberView *grabberView;

@end

@implementation NoteCell

#pragma mark - Configurator
- (void)configureCellForNote:(Note *)note {
    
    // Session
    Session *session = [[Session MR_findByAttribute:@"identifier" withValue:note.sessionIdentifier] firstObject];
    
    // Set title
    NSRange range = [note.note rangeOfString:@"\n"];
    if (range.length) {
        self.textLabel.text = [note.note substringToIndex:range.location];
    } else {
        if (note.note && ![note.note isEqualToString:@""]) {
            self.textLabel.text = note.note;
        } else {
            self.textLabel.text = NSLocalizedString(@"Photos", nil);
        }
    }
    
    // Set subtitle
    self.detailTextLabel.text = session.title;
    
}

#pragma mark - UITableViewCell
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    [UIView animateWithDuration:0.28
                     animations:^{
                         self.grabberView.alpha = !editing;
                         self.shouldDrag = !editing;
                     }];
    
}

#pragma mark - UIView
- (void)setup {
    
    // Set background color for custom drawing
    self.backgroundColor = [UIColor clearColor];
    
    if (!self.grabberView) {
        self.grabberView = [[GrabberView alloc] initWithFrame:self.bounds];
        [self.contentView insertSubview:self.grabberView atIndex:0];
    }
    
    self.defaultColor = [UIColor lightGrayColor];
    self.shouldAnimateIcons = NO;
    
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

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectOffset(self.textLabel.frame, 8.0, 0.0);
    self.detailTextLabel.frame = CGRectOffset(self.detailTextLabel.frame, 8.0, 0.0);
    
}

@end
