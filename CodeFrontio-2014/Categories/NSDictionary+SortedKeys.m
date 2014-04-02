//
//  NSDictionary+SortedKeys.m
//  Linz
//
//  Created by Ilter Cengiz on 17/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "NSDictionary+SortedKeys.h"

@implementation NSDictionary (SortedKeys)

- (NSArray *)sortedKeys {
    
    // Get all keys into a mutable array
    NSMutableArray *mutableAllKeys = [[self allKeys] mutableCopy];
    
    // Sort the array
    if ([[mutableAllKeys firstObject] isKindOfClass:[NSString class]]) {
        [mutableAllKeys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    } else if ([[mutableAllKeys firstObject] isKindOfClass:[NSNumber class]]) {
        [mutableAllKeys sortUsingSelector:@selector(compare:)];
    } else if ([[mutableAllKeys firstObject] isKindOfClass:[NSDate class]]) {
        [mutableAllKeys sortUsingSelector:@selector(compare:)];
    }
    
    // Return
    return mutableAllKeys;
}

@end
