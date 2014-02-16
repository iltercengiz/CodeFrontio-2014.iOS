//
//  Sponsor+Create.m
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "Sponsor+Create.h"

@implementation Sponsor (Create)

+ (Sponsor *)sponsorWithInfo:(NSDictionary *)info {
    
    // Context for current thread
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    
    // Create sponsor object in context
    Sponsor *sponsor = [Sponsor createInContext:context];
    sponsor.type = info[@"type"];
    sponsor.imageURL = info[@"imageURL"];
    sponsor.websiteURL = info[@"websiteURL"];
    
    // Save changes to the context
    [context saveToPersistentStoreAndWait];
    
    // Return
    return sponsor;
    
}

+ (BOOL)removeAllSponsors {
    // Remove all sponsors
    return [Sponsor truncateAll];
}

@end
