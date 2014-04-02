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

@interface CalendarTimeCell ()

@property (nonatomic) NSDateFormatter *formatter;

@end

@implementation CalendarTimeCell

#pragma mark - Configurator
- (void)configureCellForSession:(Session *)session {
    
    // Set text
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:session.timeInterval.doubleValue];
    self.timeLabel.text = [self.formatter stringFromDate:date];
    
}

#pragma mark - CalendarTimeCell
- (void)setup {
    
    // Set background color for custom drawing
    self.backgroundColor = [UIColor colorWithRed:0.153 green:0.153 blue:0.157 alpha:1];
    
    // Set frame
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    
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

#pragma mark - Getter
- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [NSDateFormatter new];
        _formatter.timeStyle = NSDateFormatterShortStyle;
    }
    return _formatter;
}

@end
