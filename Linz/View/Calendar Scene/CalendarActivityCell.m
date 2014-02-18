//
//  CalendarActivityCell.m
//  Linz
//
//  Created by Ilter Cengiz on 17/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Session.h"

#pragma mark View
#import "CalendarActivityCell.h"

@implementation CalendarActivityCell

#pragma mark - CalendarSessionCell
- (void)configureCellForSession:(Session *)session {
    
    // Set background color
    self.backgroundColor = [UIColor whiteColor];
    
    // Set frame
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    
    self.titleLabel.text = session.title;
    
}

@end
