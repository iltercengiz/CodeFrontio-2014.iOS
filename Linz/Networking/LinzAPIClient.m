//
//  LinzAPIClient.m
//  Linz
//
//  Created by Ilter Cengiz on 14/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "LinzAPIClient.h"

static NSString * const LinzAPIBaseURLString = @"http://json2014.kod.io/";

@implementation LinzAPIClient

#pragma mark - Singleton
+ (instancetype)sharedClient {
    static LinzAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:LinzAPIBaseURLString];
        sharedClient = [[LinzAPIClient alloc] initWithBaseURL:baseURL];
    });
    return sharedClient;
}

@end
