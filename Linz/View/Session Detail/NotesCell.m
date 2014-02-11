//
//  NotesCell.m
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "NotesCell.h"

@interface NotesCell () <UITextViewDelegate>

@property (nonatomic) BOOL textViewShouldClear;

@end

@implementation NotesCell

#pragma mark - Configurator
- (void)configureCellForNote:(NSString *)note {
    
    self.textView.delegate = self;
    
    if (!note) {
        self.textView.text = NSLocalizedString(@"You can write anything here...", nil);
        self.textView.textColor = [UIColor lightGrayColor];
        self.textViewShouldClear = YES;
    }
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if (self.textViewShouldClear) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = NSLocalizedString(@"You can write anything here...", nil);
        textView.textColor = [UIColor lightGrayColor];
        self.textViewShouldClear = YES;
    } else {
        self.textViewShouldClear = NO;
    }
    
}

@end
