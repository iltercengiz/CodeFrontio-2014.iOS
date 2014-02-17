//
//  Manager.h
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Manager : NSObject

#pragma mark - Properties
@property (nonatomic) NSArray *speakers;
@property (nonatomic) NSArray *sessions;
@property (nonatomic) NSArray *sponsors;

#pragma mark - Singleton
+ (instancetype)sharedManager;

#pragma mark - Setup
- (void)setupWithCompletion:(void (^)(BOOL successful))completion;

#pragma mark - Removers
- (void)removeAllSpeakers;
- (void)removeAllSessions;
- (void)removeAllSponsors;

@end
