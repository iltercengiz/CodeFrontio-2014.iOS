//
//  CalendarTimeCell.m
//  Linz
//
//  Created by Ilter Cengiz on 11/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Session.h"

#pragma mark View
#import "CalendarTimeCell.h"

@implementation CalendarTimeCell

#pragma mark - Configurator
- (void)configureCellForSession:(Session *)session {
    
    // Set background color for custom drawing
    self.backgroundColor = [UIColor colorWithRed:0.153 green:0.153 blue:0.157 alpha:1];
    
    // Set frame
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    
    // Set text
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:session.timeInterval.doubleValue];
    
    self.timeLabel.text = [formatter stringFromDate:date];
    self.timeLabel.textColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1];
    
}

@end
