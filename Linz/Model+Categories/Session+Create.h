//
//  Session+Create.h
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "Session.h"

typedef NS_ENUM(NSInteger, ActivityType) {
    ActivityTypeActivity = 0,
    ActivityTypeSession
};

@interface Session (Create)

+ (Session *)sessionWithInfo:(NSDictionary *)info;
+ (BOOL)removeAllSessions;

@end
