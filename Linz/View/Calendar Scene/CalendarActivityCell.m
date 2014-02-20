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
    self.backgroundColor = [UIColor clearColor];
    
    // Set frame
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    
    // Set image if any
    self.imageView.image = [UIImage imageNamed:session.title];
    
    // Set title & detail
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = session.title;
    self.titleLabel.textColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1];
    
}

@end
