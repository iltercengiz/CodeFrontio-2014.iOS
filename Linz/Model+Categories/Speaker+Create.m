//
//  Speaker+Create.m
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "Speaker+Create.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>

@implementation Speaker (Create)

+ (Speaker *)speakerWithInfo:(NSDictionary *)info {
    
    // Create speaker object in context
    Speaker *speaker = [Speaker MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    speaker.name = info[@"full_name"];
    speaker.title = info[@"title"];
    speaker.detail = info[@"detail"];
    speaker.identifier = info[@"id"];
    speaker.avatar = [info[@"avatar"] isEqualToString:@""] ? nil : [@"http://linz.kod.io/public/images/speakers/" stringByAppendingString:info[@"avatar"]];
    speaker.github = [info[@"github"] isEqualToString:@""] ? nil : [@"http://github.com/" stringByAppendingString:info[@"github"]];
    speaker.twitter = [info[@"twitter"] isEqualToString:@""] ? nil : [@"http://twitter.com/" stringByAppendingString:info[@"twitter"]];
    
    // Save changes
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) NSLog(@"Save successful!");
        else NSLog(@"Save failed with error: %@", error);
    }];
    
    // Return
    return speaker;
    
}

@end
