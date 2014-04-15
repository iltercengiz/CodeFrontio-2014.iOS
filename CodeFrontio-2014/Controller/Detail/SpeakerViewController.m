//
//  SpeakerViewController.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 14/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Speaker.h"

#pragma mark View
#import "SocialCell.h"

#pragma mark Controller
#import "SpeakerViewController.h"

#pragma mark Pods
#import <CHTwitterCover/UIScrollView+TwitterCover.h>
#import <AFNetworking/AFNetworking.h>
#import <TMCache/TMCache.h>

@interface SpeakerViewController ()

@end

@implementation SpeakerViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = self.speaker.name;
    
    UIScrollView *scrollView = self.tableView;
    
//    [scrollView addTwitterCoverWithImage:[UIImage imageNamed:@"Speaker-placeholder"]];
    
    __weak NSString *weakString = self.speaker.avatar;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[TMCache sharedCache] objectForKey:weakString
                                      block:^(TMCache *cache, NSString *key, id object) {
                                          UIImage *image = object;
                                          if (image)
                                              dispatch_async(dispatch_get_main_queue(), ^{ [scrollView addTwitterCoverWithImage:image]; });
                                          else {
                                              NSURL *imageURL = [NSURL URLWithString:weakString];
                                              NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
                                              AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                                              requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
                                              [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  UIImage *image = responseObject;
                                                  [scrollView addTwitterCoverWithImage:image];
                                                  [cache setObject:image forKey:weakString];
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
                                              [requestOperation start];
                                          }
                                      }];
    });
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), CHTwitterCoverViewHeight)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    UIScrollView *scrollView = self.tableView;
    [scrollView removeTwitterCoverView];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SocialCell *(^getSocialCell)(Speaker *speaker, NSIndexPath *indexPath) = ^SocialCell *(Speaker *speaker, NSIndexPath *indexPath) {
        SocialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"socialCell" forIndexPath:indexPath];
        [cell configureCellForSpeaker:speaker];
        return cell;
    };
    
    UITableViewCell *(^getBioCell)(Speaker *speaker, NSIndexPath *indexPath) = ^UITableViewCell *(Speaker *speaker, NSIndexPath *indexPath) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bioCell" forIndexPath:indexPath];
        cell.textLabel.text = speaker.detail;
        return cell;
    };
    
    if (indexPath.row == 0)
        return getSocialCell(self.speaker, indexPath);
    else
        return getBioCell(self.speaker, indexPath);
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
        return tableView.rowHeight;
    else {
        
        NSString *bio = self.speaker.detail;
        
        CGSize size = [bio boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.frame), CGFLOAT_MAX)
                                        options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]}
                                        context:nil].size;
        
        if (size.height > 64.0)
            return size.height + 8.0;
        
    }
    
    return tableView.rowHeight;
    
}

@end
