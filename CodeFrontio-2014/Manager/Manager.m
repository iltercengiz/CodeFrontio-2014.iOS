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
#import "Speaker+Create.h"
#import "Session+Create.h"
#import "Sponsor+Create.h"
#import "News+Create.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface Manager () <UIAlertViewDelegate>

@property NSMutableDictionary *localVersion;
@property NSMutableDictionary *localStatus;

@end

@implementation Manager

@synthesize speakers = _speakers;
@synthesize sessions = _sessions;
@synthesize sponsors = _sponsors;
@synthesize news = _news;

@synthesize sessionsTracked = _sessionsTracked;

@synthesize localVersion = _localVersion;
@synthesize localStatus = _localStatus;

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
    
    if (_speakers) {
        return _speakers;
    }
    
    _speakers = [Speaker MR_findAllSortedBy:@"identifier" ascending:YES];
    return _speakers;
    
}
- (NSArray *)sessions {
    
    if (_sessions) {
        return _sessions;
    }
    
    NSArray *sessions = [[Session MR_findAll] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"track" ascending:YES],
                                                                            [NSSortDescriptor sortDescriptorWithKey:@"timeInterval" ascending:YES]]];
    
    _sessions = sessions;
    
    return _sessions;
    
}
- (NSArray *)sponsors {
    
    if (_sponsors) {
        return _sponsors;
    }
    
    _sponsors = [[Sponsor MR_findAll] sortedArrayUsingDescriptors:@[
                                                                    [NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:YES],
                                                                    [NSSortDescriptor sortDescriptorWithKey:@"subpriority" ascending:YES]
                                                                    ]];
    return _sponsors;
    
}
- (NSArray *)news {
    
    if (_news) {
        return _news;
    }
    
    _news = [News MR_findAllSortedBy:@"identifier" ascending:YES];
    return _news;
    
}

- (NSDictionary *)sessionsTracked {
    
    if (_sessionsTracked) {
        return _sessionsTracked;
    }
    
    NSMutableDictionary *sessionsTracked = [NSMutableDictionary dictionary];
    NSMutableArray *track;
    
    for (Session *session in self.sessions) {
        
        track = sessionsTracked[session.track];
        
        if (!track) {
            track = [NSMutableArray array];
            sessionsTracked[session.track] = track;
        }
        
        [track addObject:session];
        
    }
    
    [sessionsTracked enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSMutableArray *sessions, BOOL *stop) {
        [sessions sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"track" ascending:YES],
                                         [NSSortDescriptor sortDescriptorWithKey:@"timeInterval" ascending:YES]]];
    }];
    
    _sessionsTracked = sessionsTracked;
    
    return _sessionsTracked;
    
}

- (NSMutableDictionary *)localVersion {
    if (!_localVersion) {
        _localVersion = [@{} mutableCopy];
    }
    return _localVersion;
}
- (NSMutableDictionary *)localStatus {
    if (!_localStatus) {
        _localStatus = [@{} mutableCopy];
    }
    return _localStatus;
}

#pragma mark - Setter
- (void)setSpeakers:(NSArray *)speakers {
    _speakers = speakers;
}
- (void)setSessions:(NSArray *)sessions {
    _sessions = sessions;
}
- (void)setSponsors:(NSArray *)sponsors {
    _sponsors = sponsors;
}
- (void)setNews:(NSArray *)news {
    _news = news;
}

- (void)setSessionsTracked:(NSDictionary *)sessionsTracked {
    _sessionsTracked = sessionsTracked;
}

- (void)setLocalVersion:(NSMutableDictionary *)localVersion {
    _localVersion = localVersion;
}
- (void)setLocalStatus:(NSMutableDictionary *)localStatus {
    _localStatus = localStatus;
}

#pragma mark - Setup
- (void)setupWithCompletion:(void (^)())completion {
    
    // Get the latest download version info
    self.localVersion = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"version"] mutableCopy];
    // If there isn't any version stored, create a version data with zeros
    if (!self.localVersion[@"speakers"]) self.localVersion[@"speakers"] = @0;
    if (!self.localVersion[@"sessions"]) self.localVersion[@"sessions"] = @0;
    if (!self.localVersion[@"sponsors"]) self.localVersion[@"sponsors"] = @0;
    if (!self.localVersion[@"news"]) self.localVersion[@"news"] = @0;
    
    if (!self.localStatus[@"speakers"]) self.localStatus[@"speakers"] = @NO;
    if (!self.localStatus[@"sessions"]) self.localStatus[@"sessions"] = @NO;
    if (!self.localStatus[@"sponsors"]) self.localStatus[@"sponsors"] = @NO;
    if (!self.localStatus[@"news"]) self.localStatus[@"news"] = @NO;
    
    // Error block
    // Will be used to terminate the app if there is an connection error and there's not any stored data
    void (^errorBlock)(NSError *error) = ^(NSError *error) {
        // NSLog(@"Error: %@", error.description);
        // Inform user that applciation will exit
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No connection", nil)
                                                        message:NSLocalizedString(@"Internet needed", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
    };
    
    // Completion block
    void (^completionBlock)(NSString *identifier, NSNumber *versionNumber, BOOL success) = ^(NSString *identifier, NSNumber *versionNumber, BOOL success) {
        
        // Get to main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // identifier is either @"speakers" or @"sessions" or @"sponsors"
            // Check success status
            if (success) {
                [self.localVersion setObject:versionNumber forKey:identifier]; // Update local version
                [self.localStatus setObject:@YES forKey:identifier]; // Update local status
            } else {
                // Check if there is any local data
                NSArray *array = [self valueForKey:identifier]; // This gets either speakers or sessions or sponsors
                if (array.count) {
                    [self.localStatus setObject:@YES forKey:identifier]; // Update local status
                } else {
                    errorBlock(nil);
                }
            }
            
            // Check if all statuses are O.K.
            if ([self.localStatus[@"speakers"] boolValue] &&
                [self.localStatus[@"sessions"] boolValue] &&
                [self.localStatus[@"sponsors"] boolValue] &&
                [self.localStatus[@"news"] boolValue])
            {
                
                // Call completion
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
                
                // Save the version data
                [[NSUserDefaults standardUserDefaults] setObject:self.localVersion forKey:@"version"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
        });
        
    };
    
    // Fetch the latest version numbers
    [[LinzAPIClient sharedClient] GET:@"/api/version/index.json"
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  [self setupSessionsWithRemoteVersion:responseObject completion:completionBlock];
                                  [self setupSponsorsWithRemoteVersion:responseObject completion:completionBlock];
                                  [self setupSpeakersWithRemoteVersion:responseObject completion:completionBlock];
                                  [self setupNewsWithRemoteVersion:responseObject completion:completionBlock];
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  
                                  double speakers = [self.localVersion[@"speakers"] doubleValue];
                                  double sessions = [self.localVersion[@"sessions"] doubleValue];
                                  double sponsors = [self.localVersion[@"sponsors"] doubleValue];
                                  double news = [self.localVersion[@"news"] doubleValue];
                                  
                                  // Check the latest download version
                                  // And decide to proceed or terminate
                                  if (speakers >= 1.0 && sessions >= 1.0 && sponsors >= 1.0 && news >= 1.0) {
                                      // proceedBlock(nil, YES, self.localVersion);
                                      completion();
                                  } else {
                                      errorBlock(error);
                                  }
                              }];
}

- (void)setupSpeakersWithRemoteVersion:(NSDictionary *)remoteVersion completion:(void (^)(NSString *identifier, NSNumber *versionNumber, BOOL success))completion {
    // Check version and download new data if needed
    if ([self.localVersion[@"speakers"] compare:remoteVersion[@"speakers"]] == NSOrderedAscending) {
        // Remove local data
        [Speaker MR_truncateAll];
        // Fetch all speakers
        [[LinzAPIClient sharedClient] GET:@"/api/speakers/index.json"
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      
                                      for (NSDictionary *speakerInfo in responseObject) {
                                          [Speaker speakerWithInfo:speakerInfo];
                                      }
                                      
                                      completion(@"speakers", remoteVersion[@"speakers"], YES);
                                      
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      completion(@"speakers", remoteVersion[@"speakers"], NO);
                                  }];
    } else {
        completion(@"speakers", self.localVersion[@"speakers"], YES);
    }
}
- (void)setupSessionsWithRemoteVersion:(NSDictionary *)remoteVersion completion:(void (^)(NSString *identifier, NSNumber *versionNumber, BOOL success))completion {
    // Check version and download new data if needed
    if ([self.localVersion[@"sessions"] compare:remoteVersion[@"sessions"]] == NSOrderedAscending) {
        // Remove local data
        [Session MR_truncateAll];
        // Fetch all sessions
        [[LinzAPIClient sharedClient] GET:@"/api/sessions/index.json"
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      
                                      for (NSDictionary *sessionInfo in responseObject) {
                                          [Session sessionWithInfo:sessionInfo];
                                      }
                                      
                                      completion(@"sessions", remoteVersion[@"sessions"], YES);
                                      
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      completion(@"sessions", remoteVersion[@"sessions"], NO);
                                  }];
    } else {
        completion(@"sessions", self.localVersion[@"sessions"], YES);
    }
}
- (void)setupSponsorsWithRemoteVersion:(NSDictionary *)remoteVersion completion:(void (^)(NSString *identifier, NSNumber *versionNumber, BOOL success))completion {
    // Check version and download new data if needed
    if ([self.localVersion[@"sponsors"] compare:remoteVersion[@"sponsors"]] == NSOrderedAscending) {
        // Remove local data
        [Sponsor MR_truncateAll];
        // Fetch all sponsors
        [[LinzAPIClient sharedClient] GET:@"/api/sponsors/index.json"
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      
                                      for (NSDictionary *groupInfo in responseObject) {
                                          
                                          NSArray *sponsors = groupInfo[@"sponsors"];
                                          
                                          NSString *type = groupInfo[@"type"];
                                          NSInteger priority = [responseObject indexOfObject:groupInfo];
                                          
                                          for (NSDictionary *sponsorInfo in sponsors) {
                                              NSInteger subpriority = [sponsors indexOfObject:sponsorInfo];
                                              
                                              [Sponsor sponsorWithInfo:@{@"type": type,
                                                                         @"imageURL": sponsorInfo[@"imageURL"],
                                                                         @"websiteURL": sponsorInfo[@"websiteURL"],
                                                                         @"priority": @(priority),
                                                                         @"subpriority": @(subpriority),
                                                                         @"identifier": sponsorInfo[@"id"]}];
                                              
                                          }
                                          
                                      }
                                      
                                      completion(@"sponsors", remoteVersion[@"sponsors"], YES);
                                      
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      completion(@"sponsors", remoteVersion[@"sponsors"], NO);
                                  }];
    } else {
        completion(@"sponsors", self.localVersion[@"sponsors"], YES);
    }
}
- (void)setupNewsWithRemoteVersion:(NSDictionary *)remoteVersion completion:(void (^)(NSString *identifier, NSNumber *versionNumber, BOOL success))completion {
    // Check version and download new data if needed
    if ([self.localVersion[@"news"] compare:remoteVersion[@"news"]] == NSOrderedAscending) {
        // Remove local data
        [News MR_truncateAll];
        // Fetch all news
        [[LinzAPIClient sharedClient] GET:@"/api/news/index.json"
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      
                                      for (NSDictionary *newsInfo in responseObject) {
                                          NSMutableDictionary *mutableNewsInfo = [newsInfo mutableCopy];
                                          mutableNewsInfo[@"identifier"] = @([responseObject indexOfObject:newsInfo]);
                                          [News newsWithInfo:mutableNewsInfo];
                                      }
                                      
                                      completion(@"news", remoteVersion[@"news"], YES);
                                      
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      completion(@"news", remoteVersion[@"news"], NO);
                                  }];
    } else {
        completion(@"news", self.localVersion[@"news"], YES);
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    exit(0); // Kill the app!
}

@end
