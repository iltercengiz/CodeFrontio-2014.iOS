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

#pragma mark - Configurator
- (void)configureCellForSession:(Session *)session {
    
    // Set image if any
    self.imageView.image = [UIImage imageNamed:session.title];
    
    // Set title & detail
    self.titleLabel.text = session.title;
    
}

#pragma mark - CalendarActivityCell
- (void)setup {
    
    // Set background color
    self.backgroundColor = [UIColor clearColor];
    
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

@end
