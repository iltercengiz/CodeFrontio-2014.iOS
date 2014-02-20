//
//  MenuCell.h
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ContentType) {
    ContentTypeCalendar = 0,
    ContentTypeFavourites,
    ContentTypeNotes,
    ContentTypeVenue,
    ContentTypeSponsors
};

@interface MenuCell : UITableViewCell

#pragma mark - Configurator
- (void)configureCellForType:(ContentType)contentType;

@end
