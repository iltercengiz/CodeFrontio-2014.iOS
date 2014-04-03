//
//  MenuCell.m
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "MenuCell.h"

@interface MenuCell ()

@end

@implementation MenuCell

#pragma mark - Configurator
- (void)configureCellForType:(ContentType)contentType {
    
    // Set background color for custom drawing
    self.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    // Set icon
    self.imageView.image = [self imageForContentType:contentType];
    self.imageView.highlightedImage = [self highlightedImageForContentType:contentType];
    
    // Set text
    self.textLabel.text = [self stringForContentType:contentType];
    self.textLabel.textColor = [UIColor colorWithRed:0.149 green:0.161 blue:0.173 alpha:1];
    
}

- (NSString *)stringForContentType:(ContentType)contentType {
    switch (contentType) {
        case ContentTypeCalendar: return NSLocalizedString(@"Calendar", nil); break;
        case ContentTypeFavourites: return NSLocalizedString(@"Favourites", nil); break;
        case ContentTypeNotes: return NSLocalizedString(@"Notes", nil); break;
        case ContentTypeVenue: return NSLocalizedString(@"Venue", nil); break;
        case ContentTypeSponsors: return NSLocalizedString(@"Sponsors", nil); break;
        default: break;
    }
    return nil;
}
- (UIImage *)imageForContentType:(ContentType)contentType {
    switch (contentType) {
        case ContentTypeCalendar: return [UIImage imageNamed:@"side-menu-calendar"]; break;
        case ContentTypeFavourites: return [UIImage imageNamed:@"side-menu-favourites"]; break;
        case ContentTypeNotes: return [UIImage imageNamed:@"side-menu-notes"]; break;
        case ContentTypeVenue: return [UIImage imageNamed:@"side-menu-venue"]; break;
        case ContentTypeSponsors: return [UIImage imageNamed:@"side-menu-supporters"]; break;
        default: break;
    }
    return nil;
}
- (UIImage *)highlightedImageForContentType:(ContentType)contentType {
    switch (contentType) {
        case ContentTypeCalendar: return [UIImage imageNamed:@"side-menu-calendar-selected"]; break;
        case ContentTypeFavourites: return [UIImage imageNamed:@"side-menu-favourites-selected"]; break;
        case ContentTypeNotes: return [UIImage imageNamed:@"side-menu-notes-selected"]; break;
        case ContentTypeVenue: return [UIImage imageNamed:@"side-menu-venue-selected"]; break;
        case ContentTypeSponsors: return [UIImage imageNamed:@"side-menu-supporters-selected"]; break;
        default: break;
    }
    return nil;
}

#pragma mark - UIView
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath;
    
    // Lines
    // Upper line
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath setLineWidth:1.0];
    [bezierPath moveToPoint:(CGPoint){0.0, 1.0}];
    [bezierPath addLineToPoint:(CGPoint){CGRectGetWidth(self.frame), 1.0}];
    [[UIColor colorWithRed:0.376 green:0.808 blue:0.867 alpha:1] setStroke];
    [bezierPath stroke];
    
    // Lower line
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath setLineWidth:1.0];
    [bezierPath moveToPoint:(CGPoint){0.0, CGRectGetHeight(self.frame)}];
    [bezierPath addLineToPoint:(CGPoint){CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)}];
    [[UIColor colorWithRed:0.000 green:0.663 blue:0.855 alpha:1] setStroke];
    [bezierPath stroke];
    
    // Selected indicator and icon highlighting
    bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetWidth(rect) - 21.0, 2.0, 20.0, CGRectGetHeight(rect) - 3.0)];
    if (self.selected) {
        [[UIColor colorWithRed:0.965 green:0.620 blue:0.153 alpha:1] setFill];
        self.imageView.highlighted = YES;
    } else {
        [[UIColor colorWithRed:0.392 green:0.392 blue:0.400 alpha:1] setFill];
        self.imageView.highlighted = NO;
    }
    [bezierPath fill];
    
}

#pragma mark - UITableViewCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Change text color
    if (selected) {
        self.textLabel.textColor = [UIColor colorWithRed:0.965 green:0.620 blue:0.153 alpha:1];
    } else {
        self.textLabel.textColor = [UIColor colorWithRed:0.149 green:0.161 blue:0.173 alpha:1];
    }
    
    [self setNeedsDisplay];
}

@end
