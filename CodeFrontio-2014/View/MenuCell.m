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
    self.contentView.backgroundColor = [UIColor P_blueishWhiteColor];
    
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
        self.imageView.highlighted = YES;
    } else {
        self.textLabel.textColor = [UIColor P_lightBlueColor];
        self.imageView.highlighted = NO;
    }
    
}

#pragma mark - Configurator
- (void)configureCellForType:(ContentType)contentType {
    
    // Set icon
    self.imageView.image = [self imageForContentType:contentType];
    self.imageView.highlightedImage = [self highlightedImageForContentType:contentType];
    
    // Set text
    self.textLabel.text = [self stringForContentType:contentType];
    
}

- (NSString *)stringForContentType:(ContentType)contentType {
    switch (contentType) {
        case ContentTypeCalendar: return NSLocalizedString(@"Calendar", nil); break;
        case ContentTypeFavourites: return NSLocalizedString(@"Favourites", nil); break;
        case ContentTypeNotes: return NSLocalizedString(@"Notes", nil); break;
        case ContentTypeNews: return NSLocalizedString(@"News", nil);
        case ContentTypeSponsors: return NSLocalizedString(@"Sponsors", nil); break;
        case ContentTypeTicket: return NSLocalizedString(@"Ticket", nil); break;
        case ContentTypeTwitter: return NSLocalizedString(@"@codefrontio", nil); break;
        default: break;
    }
    return nil;
}
- (UIImage *)imageForContentType:(ContentType)contentType {
    switch (contentType) {
        case ContentTypeCalendar: return [UIImage imageNamed:@"Calendar"]; break;
        case ContentTypeFavourites: return [UIImage imageNamed:@"Favourites"]; break;
        case ContentTypeNotes: return [UIImage imageNamed:@"Notes"]; break;
        case ContentTypeNews: return [UIImage imageNamed:@"Bullhorn"]; break;
        case ContentTypeSponsors: return [UIImage imageNamed:@"Sponsors"]; break;
        case ContentTypeTicket: return [UIImage imageNamed:@"Buy a Ticket"]; break;
        case ContentTypeTwitter: return [UIImage imageNamed:@"Twitter-sidemenu"]; break;
        default: break;
    }
    return nil;
}
- (UIImage *)highlightedImageForContentType:(ContentType)contentType {
    switch (contentType) {
        case ContentTypeCalendar: return [UIImage imageNamed:@"Calendar-selected"]; break;
        case ContentTypeFavourites: return [UIImage imageNamed:@"Favourites-selected"]; break;
        case ContentTypeNotes: return [UIImage imageNamed:@"Notes-selected"]; break;
        case ContentTypeNews: return [UIImage imageNamed:@"Bullhorn-selected"]; break;
        case ContentTypeSponsors: return [UIImage imageNamed:@"Sponsors-selected"]; break;
        case ContentTypeTicket:
        case ContentTypeTwitter:
            return nil; break;
        default: break;
    }
    return nil;
}

@end
