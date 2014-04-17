//
//  News+Create.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 16/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "News+Create.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>

@implementation News (Create)

+ (News *)newsWithInfo:(NSDictionary *)info {
    
    // Create news object in context
    News *news = [News MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    news.date = info[@"date"];
    news.detail = info[@"description"];
    news.identifier = info[@"identifier"];
    
    // Save changes
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        // if (success) NSLog(@"Save successful!");
        // else NSLog(@"Save failed with error: %@", error);
    }];
    
    // Return
    return news;
    
}

@end
