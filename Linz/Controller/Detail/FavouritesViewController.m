//
//  FavouritesViewController.m
//  Linz
//
//  Created by Ilter Cengiz on 18/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Manager
#import "Manager.h"

#pragma mark Model
#import "Session.h"
#import "Speaker.h"

#pragma mark Controller
#import "FavouritesViewController.h"

#pragma mark Pods
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface FavouritesViewController ()

@property (nonatomic) NSArray *sessions;

@end

@implementation FavouritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Get sessions
    NSArray *sessions = [Manager sharedManager].sessions;
    self.sessions = [sessions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"favourited == %@", @YES]];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sessions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell" forIndexPath:indexPath];
    
    Session *session = self.sessions[indexPath.row];
    Speaker *speaker = [[Speaker MR_findByAttribute:@"identifier" withValue:session.speakerIdentifier] firstObject];
    
    // Set image
    cell.imageView.layer.cornerRadius = 8.0;
    cell.imageView.clipsToBounds = YES;
    
    __weak typeof(cell.imageView) weakImageView = cell.imageView;
    
    NSString *imageURLString = speaker.avatar;
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:@"Placeholder"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       // To-do: cache image
                                       weakImageView.image = image;
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       NSLog(@"Error getting image: %@", error.description);
                                   }];
    
    // Set title
    cell.textLabel.text = session.title;
    
    // Set subtitle
    cell.detailTextLabel.text = speaker.name;
    
    return cell;
}

@end
