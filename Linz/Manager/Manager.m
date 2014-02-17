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

@interface Manager () <UIAlertViewDelegate>

@end

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
    
    // Get the latest download version info
    NSMutableDictionary *localVersion = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"version"] mutableCopy];
    // If there isn't any version stored, create a version data with zeros
    if (!localVersion) {
        localVersion = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0, @"speakers", @0, @"sessions", @0, @"sponsors", nil];
    }
    
    // Error block
    // Will be used to terminate the app if there is an connection error
    void (^errorBlock)(NSError *error) = ^(NSError *error) {
        NSLog(@"Error: %@", error.description);
        // Inform user that applciation will exit
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No connection!", nil)
                                                        message:NSLocalizedString(@"In order to fetch initial data, I need an active internet connection.\nPlease check the internet connection and open me again.\nI'm killing myself now.", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
    };
    
    // Proceed block
    void (^proceedBlock)(NSString *completionIdentifier, BOOL success, NSDictionary *version) = ^(NSString *completionIdentifier, BOOL success, NSDictionary *version) {
        
        // Check if successful, may be continued, or should terminate
        if ([completionIdentifier isEqualToString:@"speakers"]) {
            if (success)
                [localVersion setObject:version[completionIdentifier] forKey:completionIdentifier];
            else if (!success && self.speakers.count == 0)
                errorBlock(nil);
        }
        if ([completionIdentifier isEqualToString:@"sessions"]) {
            if (success)
                [localVersion setObject:version[completionIdentifier] forKey:completionIdentifier];
            else if (!success && self.sessions.count == 0)
                errorBlock(nil);
        }
        if ([completionIdentifier isEqualToString:@"sponsors"]) { // Here I should do something else
            if (success)
                [localVersion setObject:version[completionIdentifier] forKey:completionIdentifier];
            else if (!success && self.sponsors.count == 0)
                errorBlock(nil);
        }
        
        if (self.speakers.count == 0 || self.sessions.count == 0 || self.sponsors.count == 0) {
            return;
        }
        
        // Call completion block to proceed
        completion(YES);
        
        // Save the version data
        [[NSUserDefaults standardUserDefaults] setObject:localVersion forKey:@"version"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    };
    
    // Fetch the latest version numbers
    [[LinzAPIClient sharedClient] GET:@"/version"
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  // Check versions and download new data if needed
                                  if ([localVersion[@"speakers"] compare:responseObject[@"speakers"]] == NSOrderedAscending) {
                                      [self removeAllSpeakers];
                                      [self setupSpeakersWithCompletion:^(NSString *completionIdentifier, BOOL success) {
                                          proceedBlock(completionIdentifier, success, responseObject);
                                      }];
                                  }
                                  if ([localVersion[@"sessions"] compare:responseObject[@"sessions"]] == NSOrderedAscending) {
                                      [self removeAllSessions];
                                      [self setupSessionsWithCompletion:^(NSString *completionIdentifier, BOOL success) {
                                          proceedBlock(completionIdentifier, success, responseObject);
                                      }];
                                  }
                                  if ([localVersion[@"sponsors"] compare:responseObject[@"sponsors"]] == NSOrderedAscending) {
                                      [self removeAllSponsors];
                                      [self setupSponsorsWithCompletion:^(NSString *completionIdentifier, BOOL success) {
                                          proceedBlock(completionIdentifier, success, responseObject);
                                      }];
                                  }
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  
                                  double speakers = [localVersion[@"speakers"] doubleValue];
                                  double sessions = [localVersion[@"sessions"] doubleValue];
                                  double sponsors = [localVersion[@"sponsors"] doubleValue];
                                  
                                  // Check the latest download version
                                  // And decide to proceed or terminate
                                  if (speakers >= 1.0 && sessions >= 1.0 && sponsors >= 1.0) {
                                      completion(YES);
                                  } else {
                                      errorBlock(error);
                                  }
                              }];
}

- (void)setupSpeakersWithCompletion:(void (^)(NSString *completionIdentifier, BOOL success))completion {
    // Fetch all speakers
    [[LinzAPIClient sharedClient] GET:@"/speakers"
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  // responseObject holds info for all speakers
                                  for (NSDictionary *speakerInfo in responseObject) {
                                      [Speaker speakerWithInfo:speakerInfo];
                                  }
                                  completion(@"speakers", YES);
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  completion(@"speakers", NO);
                              }];
}
- (void)setupSessionsWithCompletion:(void (^)(NSString *completionIdentifier, BOOL success))completion {
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
                                  completion(@"sessions", YES);
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  completion(@"sessions", NO);
                              }];
}
- (void)setupSponsorsWithCompletion:(void (^)(NSString *completionIdentifier, BOOL success))completion {
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
                                  completion(@"sponsors", YES);
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  completion(@"sponsors", NO);
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    exit(0); // Kill the app!
}

@end
