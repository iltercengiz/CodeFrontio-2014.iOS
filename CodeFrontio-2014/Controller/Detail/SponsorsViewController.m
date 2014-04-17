//
//  SponsorsViewController.m
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Manager
#import "Manager.h"

#pragma mark Categories
#import "NSDictionary+SortedKeys.h"
#import "UIColor+Palette.h"

#pragma mark Model
#import "Sponsor.h"

#pragma mark View
#import "SponsorCell.h"

#pragma mark Controller
#import "SponsorsViewController.h"

@interface SponsorsViewController ()

@property (nonatomic) NSMutableArray *sponsorsArray;
@property (nonatomic) NSMutableDictionary *sponsorsDictionary;

@end

@implementation SponsorsViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Sponsors", nil);
    
    // Set separator stuff
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor P_lightBlueColor];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Get sponsors
    NSArray *sponsors = [Manager sharedManager].sponsors;
    
    for (Sponsor *sponsor in sponsors) {
        if (![sponsor.websiteURL isEqualToString:@"http://linz.kod.io"]) {
            [self addSponsor:sponsor];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter
- (NSMutableArray *)sponsorsArray {
    if (!_sponsorsArray) {
        _sponsorsArray = [NSMutableArray array];
    }
    return _sponsorsArray;
}
- (NSMutableDictionary *)sponsorsDictionary {
    if (!_sponsorsDictionary) {
        _sponsorsDictionary = [NSMutableDictionary dictionary];
    }
    return _sponsorsDictionary;
}

#pragma mark - Helpers
- (NSArray *)sponsorsAtSection:(NSInteger)section {
    NSArray *keys = [self.sponsorsDictionary sortedKeys];
    NSNumber *key = keys[section];
    NSArray *sponsors = self.sponsorsDictionary[key];
    return sponsors;
}
- (Sponsor *)sponsorAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sponsors = [self sponsorsAtSection:indexPath.section];
    Sponsor *sponsor = sponsors[indexPath.row];
    return sponsor;
}
- (void)addSponsor:(Sponsor *)sponsor {
    
    // Check if sponsor is already added
    if ([self.sponsorsArray indexOfObject:sponsor] != NSNotFound) {
        return;
    }
    
    // Add to the dictionary
    NSNumber *key = sponsor.priority;
    
    // Get the array, if there isn't any, create and add one
    NSMutableArray *sponsors = self.sponsorsDictionary[key];
    if (!sponsors) {
        sponsors = [NSMutableArray array];
        [self.sponsorsDictionary setObject:sponsors forKey:key];
    }
    
    // Add the sponsor to the array
    [sponsors addObject:sponsor];
    
    // Sort the array
    [sponsors sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"subpriority" ascending:YES]]];
    
    // Add sponsor to the sponsorsArray
    [self.sponsorsArray addObject:sponsor];
    
    // Sort the array
    [self.sponsorsArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"subpriority" ascending:YES]]];
    
    // Reload tableView
    [self.tableView reloadData];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sponsorsDictionary.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self sponsorsAtSection:section].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SponsorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sponsorCell" forIndexPath:indexPath];
    Sponsor *sponsor = [self sponsorAtIndexPath:indexPath];
    [cell configureCellForSponsor:sponsor];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Sponsor *sponsor = [self sponsorAtIndexPath:indexPath];
    NSURL *websiteURL = [NSURL URLWithString:sponsor.websiteURL];
    [[UIApplication sharedApplication] openURL:websiteURL];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    Sponsor *sponsor = [self sponsorAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.frame), tableView.sectionHeaderHeight)];
    
    titleLabel.backgroundColor = [UIColor P_lightGrayColor];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    titleLabel.text = sponsor.type;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor P_blueColor];
    
    return titleLabel;
    
}

@end
