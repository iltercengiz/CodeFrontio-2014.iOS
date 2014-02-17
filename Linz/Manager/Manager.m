//
//  Manager.m
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Manager
#import "Manager.h"

#pragma mark Networking
#import "LinzAPIClient.h"

#pragma mark Model
#import "Sponsor+Create.h"
#import "Session+Create.h"
#import "Speaker+Create.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>

@implementation Manager

#pragma mark - Singleton
+ (instancetype)sharedManager {
    static Manager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [Manager new];
    });
    return sharedManager;
}

#pragma mark - Getter
- (NSArray *)speakers {
    _speakers = [Speaker MR_findAllSortedBy:@"identifier" ascending:YES];
    return _speakers;
}
- (NSArray *)sessions {
    _sessions = [Session MR_findAllSortedBy:@"sortingIndex" ascending:YES];
    return _sessions;
}
- (NSArray *)sponsors {
    _sponsors = [[Sponsor MR_findAll] sortedArrayUsingDescriptors:@[
                                                                    [NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:YES],
                                                                    [NSSortDescriptor sortDescriptorWithKey:@"subpriority" ascending:YES]
                                                                    ]];
    return _sponsors;
}

#pragma mark - Setup
- (void)setupWithCompletion:(void (^)(BOOL successful))completion {
    // Proceed block
    void (^proceedBlock)() = ^{
        if (!self.speakers || !self.sessions || !self.sponsors) {
            return;
        }
        completion(YES);
    };
    // Fetch the latest version
    [[LinzAPIClient sharedClient] GET:@"/version"
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  // Get the latest download version info
                                  NSDictionary *version = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"version"];
                                  // If there isn't any version stored, create a version data with zeros
                                  if (!version) {
                                      version = @{@"speakers": @0, @"sessions": @0, @"sponsors": @0};
                                  }
                                  // Check versions and download new data if needed
                                  if ([version[@"speakers"] compare:responseObject[@"speakers"]] == NSOrderedAscending) {
                                      [self removeAllSpeakers];
                                      [self setupSpeakersWithCompletion:proceedBlock];
                                  }
                                  if ([version[@"sessions"] compare:responseObject[@"sessions"]] == NSOrderedAscending) {
                                      [self removeAllSessions];
                                      [self setupSessionsWithCompletion:proceedBlock];
                                  }
                                  if ([version[@"sponsors"] compare:responseObject[@"sponsors"]] == NSOrderedAscending) {
                                      [self removeAllSponsors];
                                      [self setupSponsorsWithCompletion:proceedBlock];
                                  }
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  NSLog(@"Error: %@", error.description);
                              }];
}

- (void)setupSpeakersWithCompletion:(void (^)())completion {
    // Fetch all speakers
    [[LinzAPIClient sharedClient] GET:@"/speakers"
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  // responseObject holds info for all speakers
                                  for (NSDictionary *speakerInfo in responseObject) {
                                      [Speaker speakerWithInfo:speakerInfo];
                                  }
                                  // Completion
                                  completion();
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  NSLog(@"Error: %@", error.description);
                              }];
}
- (void)setupSessionsWithCompletion:(void (^)())completion {
    // Fetch all sessions
    [[LinzAPIClient sharedClient] GET:@"/sessions"
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  // responseObject holds info for all sessions
                                  NSInteger sortingIndex = 0;
                                  for (NSDictionary *sessionInfo in responseObject) {
                                      // Add a small dictionary object to specify time cells
                                      // Check type and track values of the sessions for appropriate placing
                                      if ([sessionInfo[@"type"] isEqualToNumber:@0] ||
                                          [sessionInfo[@"track"] isEqualToNumber:@1]) // We check the track info instead of type to not to add time data twice for simultaneous sessions
                                      {
                                          // Add a session object for time cell
                                          [Session sessionWithInfo:@{@"track": @0,
                                                                     @"type": @(-1),
                                                                     @"timeInterval": sessionInfo[@"time"],
                                                                     @"sortingIndex": @(sortingIndex)}];
                                          // Increment index
                                          sortingIndex++;
                                      }
                                      // Save session
                                      NSMutableDictionary *mutableSessionInfo = [sessionInfo mutableCopy];
                                      [mutableSessionInfo setObject:@(sortingIndex) forKey:@"sortingIndex"];
                                      [Session sessionWithInfo:mutableSessionInfo];
                                      // Increment index
                                      sortingIndex++;
                                  }
                                  // Completion
                                  completion();
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  NSLog(@"Error: %@", error.description);
                              }];
}
- (void)setupSponsorsWithCompletion:(void (^)())completion {
    // Fetch all sponsors
    [[LinzAPIClient sharedClient] GET:@"/sponsors"
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  // responseObject holds info for all sponsors
                                  for (NSDictionary *groupInfo in responseObject) {
                                      NSString *type = groupInfo[@"type"];
                                      NSInteger priority = [responseObject indexOfObject:groupInfo];
                                      NSArray *sponsors = groupInfo[@"sponsors"];
                                      for (NSDictionary *sponsorInfo in sponsors) {
                                          NSInteger subpriority = [sponsors indexOfObject:sponsorInfo];
                                          [Sponsor sponsorWithInfo:@{@"type": type,
                                                                     @"imageURL": sponsorInfo[@"imageURL"],
                                                                     @"websiteURL": sponsorInfo[@"websiteURL"],
                                                                     @"priority": @(priority),
                                                                     @"subpriority": @(subpriority)}];
                                      }
                                  }
                                  // Completion
                                  completion();
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  NSLog(@"Error: %@", error.description);
                              }];
}

#pragma mark - Removers
- (void)removeAllSpeakers {
    [Speaker removeAllSpeakers];
}
- (void)removeAllSessions {
    [Session removeAllSessions];
}
- (void)removeAllSponsors {
    [Sponsor removeAllSponsors];
}

@end
