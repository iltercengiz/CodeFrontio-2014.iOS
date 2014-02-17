//
//  Speaker+Create.m
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "Speaker+Create.h"

#pragma mark Pods
#import "CoreData+MagicalRecord.h"

@implementation Speaker (Create)

+ (Speaker *)speakerWithInfo:(NSDictionary *)info {
    
    // Context for current thread
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    // Create speaker object in context
    Speaker *speaker = [Speaker MR_createInContext:context];
    speaker.name = info[@"full_name"];
    speaker.title = info[@"title"];
    speaker.detail = info[@"detail"];
    speaker.identifier = info[@"id"];
    speaker.avatar = [info[@"avatar"] isEqualToString:@""] ? nil : [@"http://linz.kod.io/public/images/speakers/" stringByAppendingString:info[@"avatar"]];
    speaker.github = [info[@"github"] isEqualToString:@""] ? nil : [@"http://github.com/" stringByAppendingString:info[@"github"]];
    speaker.twitter = [info[@"twitter"] isEqualToString:@""] ? nil : [@"http://twitter.com/" stringByAppendingString:info[@"twitter"]];
    
    // Save changes
    [context MR_saveToPersistentStoreAndWait];
    
    // Return
    return speaker;
    
}

+ (BOOL)removeAllSpeakers {
    // Remove all speakers
    return [Speaker MR_truncateAll];
}

@end
