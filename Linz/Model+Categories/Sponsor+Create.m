//
//  Sponsor+Create.m
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "Sponsor+Create.h"

#pragma mark Pods
#import "CoreData+MagicalRecord.h"

@implementation Sponsor (Create)

+ (Sponsor *)sponsorWithInfo:(NSDictionary *)info {
    
    // Context for current thread
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    // Create sponsor object in context
    Sponsor *sponsor = [Sponsor MR_createInContext:context];
    sponsor.type = info[@"type"];
    sponsor.imageURL = info[@"imageURL"];
    sponsor.websiteURL = info[@"websiteURL"];
    sponsor.priority = info[@"priority"];
    sponsor.subpriority = info[@"subpriority"];
    
    // Save changes to the context
    [context MR_saveToPersistentStoreAndWait];
    
    // Return
    return sponsor;
    
}

+ (BOOL)removeAllSponsors {
    // Remove all sponsors
    return [Sponsor MR_truncateAll];
}

@end
