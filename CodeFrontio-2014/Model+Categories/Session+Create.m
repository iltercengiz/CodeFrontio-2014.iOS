//
//  Session+Create.m
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "Session+Create.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>

@implementation Session (Create)

+ (Session *)sessionWithInfo:(NSDictionary *)info {
    
    // Create session object in context
    Session *session = [Session MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    session.title = info[@"talk_title"];
    session.detail = [info[@"talk_detail"] isKindOfClass:[NSNull class]] ? nil : info[@"talk_detail"];
    session.track = info[@"track"];
    session.timeInterval = info[@"time"];
    session.speakerIdentifier = info[@"speaker_session_ids"];
    session.identifier = info[@"id"];
    
    // Save changes
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        // if (success) NSLog(@"Save successful!");
        // else NSLog(@"Save failed with error: %@", error);
    }];
    
    // Return
    return session;
    
}

@end
