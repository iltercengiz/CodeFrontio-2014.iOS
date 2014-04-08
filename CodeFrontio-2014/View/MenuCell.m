//
//  MenuCell.m
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Categories
#import "UIColor+Palette.h"

#pragma mark View
#import "MenuCell.h"

@interface MenuCell ()

@end

@implementation MenuCell

#pragma mark - NSObject UIKit Additions
- (void)awakeFromNib {
    
    // Set background color for custom drawing
    self.backgroundColor = [UIColor clearColor];
    
    // Set text attributes
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
    self.textLabel.textColor = [UIColor P_lightBlueColor];
    
}

#pragma mark - UITableViewCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Change text color
    if (selected) {
        self.textLabel.textColor = [UIColor P_blueColor];
    } else {
        self.textLabel.textColor = [UIColor P_lightBlueColor];
    }
    
}

#pragma mark - Configurator
- (void)configureCellForType:(ContentType)contentType {
    
    // Set icon
//    self.imageView.image = [self imageForContentType:contentType];
//    self.imageView.highlightedImage = [self highlightedImageForContentType:contentType];
    
    // Set text
    self.textLabel.text = [self stringForContentType:contentType];
    
}

- (NSString *)stringForContentType:(ContentType)contentType {
    switch (contentType) {
        case ContentTypeCalendar: return NSLocalizedString(@"Calendar", nil); break;
        case ContentTypeFavourites: return NSLocalizedString(@"Favourites", nil); break;
        case ContentTypeNotes: return NSLocalizedString(@"Notes", nil); break;
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
        case ContentTypeSponsors: return [UIImage imageNamed:@"side-menu-supporters-selected"]; break;
        default: break;
    }
    return nil;
}

@end
