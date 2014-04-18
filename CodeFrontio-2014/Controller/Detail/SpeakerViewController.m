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

@property (nonatomic) NSMutableArray *profiles;

@end

@implementation SpeakerViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = self.speaker.name;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                              target:self
                                                                                              action:@selector(dismiss:)];
    }
    
    // Table view header as profile image
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), CHTwitterCoverViewHeight)];
    
    UIScrollView *scrollView = self.tableView;
    [scrollView addTwitterCoverWithImage:[UIImage imageNamed:@"Speaker-placeholder"]];
    
    // Get profile details
    if (self.speaker.twitter)
        [self.profiles addObject:@(Twitter)];

    if (self.speaker.github)
        [self.profiles addObject:@(GitHub)];

    if (self.speaker.dribbble)
        [self.profiles addObject:@(Dribbble)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    
    __weak UIScrollView *scrollView = self.tableView;
    
    __weak NSString *weakString = self.speaker.avatar;
    
    void (^setImage)(UIScrollView *scrollView, UIImage *image) = ^(UIScrollView *scrollView, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:scrollView
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [scrollView removeTwitterCoverView];
                                [scrollView addTwitterCoverWithImage:image];
                            } completion:^(BOOL finished) {
                                
                            }];
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[TMCache sharedCache] objectForKey:weakString
                                      block:^(TMCache *cache, NSString *key, id object) {
                                          UIImage *image = object;
                                          if (image)
                                              setImage(scrollView, image);
                                          else {
                                              NSURL *imageURL = [NSURL URLWithString:weakString];
                                              NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
                                              AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                                              requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
                                              [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  UIImage *image = responseObject;
                                                  setImage(scrollView, image);
                                                  [cache setObject:image forKey:weakString];
                                              } failure:nil];
                                              [requestOperation start];
                                          }
                                      }];
    });
    
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    UIScrollView *scrollView = self.tableView;
    [scrollView removeTwitterCoverView];
    
}

#pragma mark - IBActions
- (IBAction)dismiss:(id)sender {
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter
- (NSMutableArray *)profiles {
    if (!_profiles) {
        _profiles = [NSMutableArray array];
    }
    return _profiles;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + self.profiles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *(^getBioCell)(Speaker *speaker, NSIndexPath *indexPath) = ^UITableViewCell *(Speaker *speaker, NSIndexPath *indexPath) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bioCell" forIndexPath:indexPath];
        
        NSString *htmlString = [NSString stringWithFormat:@"<div style='font-size:16px; font-family:HelveticaNeue-Light;'>%@</div>", speaker.detail];
        
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                                         options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                              documentAttributes:nil
                                                                           error:nil];
        
        return cell;
        
    };
    
    SocialCell *(^getSocialCell)(ProfileType type, Speaker *speaker, NSIndexPath *indexPath) = ^SocialCell *(ProfileType type, Speaker *speaker, NSIndexPath *indexPath) {
        
        SocialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"socialCell" forIndexPath:indexPath];
        
        [cell configureCellForProfileType:type];
        
        switch (type) {
            case Twitter: cell.textLabel.text = speaker.twitter; break;
            case GitHub: cell.textLabel.text = speaker.github; break;
            case Dribbble: cell.textLabel.text = speaker.dribbble; break;
            default: break;
        }
        
        return cell;
        
    };
    
    if (indexPath.row == 0)
        return getBioCell(self.speaker, indexPath);
    else
        return getSocialCell([self.profiles[indexPath.row - 1] unsignedIntegerValue], self.speaker, indexPath);
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"<.*?>" options:0 error:nil];
        NSString *string = [regularExpression stringByReplacingMatchesInString:self.speaker.detail options:0 range:NSMakeRange(0, self.speaker.detail.length) withTemplate:@""];
        
        CGSize size = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.frame), CGFLOAT_MAX)
                                           options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]}
                                           context:nil].size;
        
        if (size.height > 48.0)
            return size.height;
        
    }
    
    return tableView.rowHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
        return;
    
    ProfileType type = [self.profiles[indexPath.row - 1] unsignedIntegerValue];
    
    NSURL *url;
    
    switch (type) {
        case Twitter: url = [NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", self.speaker.twitter]]; break;
        case GitHub: url = [NSURL URLWithString:[NSString stringWithFormat:@"http://github.com/%@", self.speaker.github]]; break;
        case Dribbble: url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dribbble.com/%@", self.speaker.dribbble]]; break;
        default: break;
    }
    
    if (url)
        [[UIApplication sharedApplication] openURL:url];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
