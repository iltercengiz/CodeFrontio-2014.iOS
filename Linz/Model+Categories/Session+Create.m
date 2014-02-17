//
//  Session+Create.m
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "Session+Create.h"
#import "Speaker.h"

#pragma mark Pods
#import "CoreData+MagicalRecord.h"

@implementation Session (Create)

+ (Session *)sessionWithInfo:(NSDictionary *)info {
    
    // Context for current thread
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    // Create session object in context
    Session *session = [Session MR_createInContext:context];
    session.title = info[@"title"];
    session.detail = info[@"detail"];
    session.track = info[@"track"];
    session.type = info[@"type"];
    session.timeInterval = info[@"time"];
    session.speakerIdentifier = info[@"speaker"];
    session.sortingIndex = info[@"sortingIndex"];
    
    // Save changes
    [context MR_saveToPersistentStoreAndWait];
    
    // Return
    return session;
    
}

+ (BOOL)removeAllSessions {
    // Remove all sessions
    return [Session MR_truncateAll];
}

@end
