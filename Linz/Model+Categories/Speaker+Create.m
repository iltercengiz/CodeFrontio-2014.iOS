//
//  Speaker+Create.m
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "Speaker+Create.h"

@implementation Speaker (Create)

+ (Speaker *)speakerWithInfo:(NSDictionary *)info {
    
    // Context for current thread
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    
    // Create speaker object in context
    Speaker *speaker = [Speaker createInContext:context];
    speaker.name = info[@"name"];
    speaker.identifier = info[@"identifier"];
    if ([info[@"avatar"] isEqualToString:@""]) {
        speaker.avatar = nil;
    } else {
        speaker.avatar = [@"http://linz.kod.io/public/images/speakers/" stringByAppendingString:info[@"avatar"]];
    }
    if ([info[@"github"] isEqualToString:@""]) {
        speaker.github = nil;
    } else {
        speaker.github = [@"http://github.com/" stringByAppendingString:info[@"github"]];
    }
    if ([info[@"twitter"] isEqualToString:@""]) {
        speaker.twitter = nil;
    } else {
        speaker.twitter = [@"http://twitter.com/" stringByAppendingString:info[@"twitter"]];
    }
    speaker.detail = info[@"detail"];
    speaker.title = info[@"title"];
    
    // Save changes
    [context saveToPersistentStoreAndWait];
    
    // Return
    return speaker;
    
}

+ (BOOL)removeAllSpeakers {
    // Remove all speakers
    return [Speaker truncateAll];
}

@end
