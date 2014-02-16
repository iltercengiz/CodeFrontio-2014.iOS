//
//  Session+Create.m
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "Session+Create.h"
#import "Speaker.h"

@implementation Session (Create)

+ (Session *)sessionWithInfo:(NSDictionary *)info {
    
    // Context for current thread
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    
    // Create session object in context
    Session *session = [Session createInContext:context];
    session.detail = info[@"detail"];
    session.title = info[@"title"];
    session.track = info[@"track"];
    session.type = info[@"type"];
    session.timeInterval = info[@"timeInterval"];
    session.speaker = [[Speaker findByAttribute:@"identifier" withValue:info[@"speaker"]] firstObject];
    
    // Save changes
    [context saveToPersistentStoreAndWait];
    
    // Return
    return session;
    
}

+ (BOOL)removeAllSessions {
    // Remove all sessions
    return [Session truncateAll];
}

@end
