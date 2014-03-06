//
//  Manager.h
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SessionType) {
    SessionTypeBreak = -1,
    SessionTypeActivity,
    SessionTypeKeynote
};

@interface Manager : NSObject

#pragma mark - Properties
@property NSArray *speakers;
@property NSArray *sessions;
@property NSArray *sponsors;

#pragma mark - Singleton
+ (instancetype)sharedManager;

#pragma mark - Setup
- (void)setupWithCompletion:(void (^)())completion;

@end
