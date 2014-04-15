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
    speaker.title = info[@"company"];
    speaker.detail = info[@"bio"];
    speaker.identifier = info[@"id"];
    speaker.avatar = [info[@"avatar"] isEqualToString:@""] ? nil : [@"http://codefront.io/public/images/speakers/" stringByAppendingString:info[@"avatar"]];
    
    if ([info[@"twitter"] isKindOfClass:[NSString class]] && ![info[@"twitter"] isEqualToString:@""])
        speaker.twitter = info[@"twitter"];
    
    if ([info[@"github"] isKindOfClass:[NSString class]] && ![info[@"github"] isEqualToString:@""])
        speaker.github = info[@"github"];
    
    if ([info[@"dribbble"] isKindOfClass:[NSString class]] && ![info[@"dribbble"] isEqualToString:@""])
        speaker.dribbble = info[@"dribbble"];
    
    // Save changes
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) NSLog(@"Save successful!");
        else NSLog(@"Save failed with error: %@", error);
    }];
    
    // Return
    return speaker;
    
}

@end
