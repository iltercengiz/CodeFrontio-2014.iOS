//
//  NotesCell.h
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Note;

@interface NotesCell : UITableViewCell

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UITextView *textView;

#pragma mark - Configurator
- (void)configureCellForNote:(Note *)note;

@end
