//
//  ActivityCell.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 15/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Session.h"

#pragma mark View
#import "ActivityCell.h"

@implementation ActivityCell

#pragma mark - NSObject UIKit Additions
- (void)awakeFromNib {
    self.layer.cornerRadius = 8.0;
    self.clipsToBounds = YES;
}

#pragma mark - UITableViewCell
- (void)prepareForReuse {
    self.textLabel.text = nil;
}

#pragma mark - ActivityCell
- (void)configureCellForSession:(Session *)session {
    self.textLabel.text = session.title;
}

@end
