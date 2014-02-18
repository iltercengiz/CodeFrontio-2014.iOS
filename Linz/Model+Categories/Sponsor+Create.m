//
//  Sponsor+Create.m
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "Sponsor+Create.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>

@implementation Sponsor (Create)

+ (Sponsor *)sponsorWithInfo:(NSDictionary *)info {
    
    // Create sponsor object in context
    Sponsor *sponsor = [Sponsor MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    sponsor.type = info[@"type"];
    sponsor.imageURL = info[@"imageURL"];
    sponsor.websiteURL = info[@"websiteURL"];
    sponsor.priority = info[@"priority"];
    sponsor.subpriority = info[@"subpriority"];
    sponsor.identifier = info[@"identifier"];
    
    // Save changes
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) NSLog(@"Save successful!");
        else NSLog(@"Save failed with error: %@", error);
    }];
    
    // Return
    return sponsor;
    
}

@end
