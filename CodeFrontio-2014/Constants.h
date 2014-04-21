//
//  Constants.h
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 09/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#ifndef CodeFrontio_2014_Constants_h
#define CodeFrontio_2014_Constants_h

static NSString * const LinzAPIBaseURLString = @"http://codefront.io/";

static NSString * const calendarSceneIdentifier = @"CalendarScene";
static NSString * const favouritesSceneIdentifier = @"FavouritesScene";
static NSString * const notesSceneIdentifier = @"NotesScene";
static NSString * const newsSceneIdentifier = @"NewsScene";
static NSString * const supportersSceneIdentifier = @"SponsorsScene";

static NSString * const takeNoteNotification = @"io.webBox.CodeFrontio-2014.takeNoteNotification";
static NSString * const didSelectSpeakerNotification = @"io.webBox.CodeFrontio-2014.didSelectSpeakerNotification";

typedef NS_ENUM(NSInteger, ContentType) {
    ContentTypeCalendar = 0,
    ContentTypeFavourites,
    ContentTypeNotes,
    ContentTypeNews,
    ContentTypeSponsors,
    ContentTypeTicket,
    ContentTypeTwitter
};

#endif
