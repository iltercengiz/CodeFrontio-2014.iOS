//
//  LinzAPIClient.h
//  Linz
//
//  Created by Ilter Cengiz on 14/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface LinzAPIClient : AFHTTPSessionManager

#pragma mark - Singleton
+ (instancetype)sharedClient;

@end
