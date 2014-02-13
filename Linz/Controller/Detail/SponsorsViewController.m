//
//  SponsorsViewController.m
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark View
#import "SponsorCell.h"

#pragma mark Controller
#import "SponsorsViewController.h"

@interface SponsorsViewController ()

@property (nonatomic) NSArray *sponsors;

@end

@implementation SponsorsViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.sponsors = @[
                      @{@"category": @"Gold",
                        @"sponsors": @[[UIImage imageNamed:@"kod-io-logo-black"],
                                       [UIImage imageNamed:@"kod-io-logo-black"],
                                       [UIImage imageNamed:@"kod-io-logo-black"],
                                       [UIImage imageNamed:@"kod-io-logo-black"],
                                       [UIImage imageNamed:@"kod-io-logo-black"]
                                       ]},
                      @{@"category": @"Silver",
                        @"sponsors": @[[UIImage imageNamed:@"kod-io-logo-black"],
                                       [UIImage imageNamed:@"kod-io-logo-black"],
                                       [UIImage imageNamed:@"kod-io-logo-black"],
                                       [UIImage imageNamed:@"kod-io-logo-black"],
                                       [UIImage imageNamed:@"kod-io-logo-black"]
                                       ]},
                      @{@"category": @"Bronze",
                        @"sponsors": @[[UIImage imageNamed:@"kod-io-logo-black"],
                                       [UIImage imageNamed:@"kod-io-logo-black"],
                                       [UIImage imageNamed:@"kod-io-logo-black"],
                                       [UIImage imageNamed:@"kod-io-logo-black"],
                                       [UIImage imageNamed:@"kod-io-logo-black"]
                                       ]}
                      ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sponsors.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sponsorsDict = self.sponsors[section];
    NSArray *sponsors = sponsorsDict[@"sponsors"];
    return sponsors.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SponsorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sponsorCell" forIndexPath:indexPath];
    
    NSDictionary *sponsorsDict = self.sponsors[indexPath.section];
    NSArray *sponsors = sponsorsDict[@"sponsors"];
    UIImage *sponsor = sponsors[indexPath.row];
    
    cell.sponsorImage.image = sponsor;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *sponsorsDict = self.sponsors[section];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.frame), tableView.sectionHeaderHeight)];
    
    titleLabel.text = sponsorsDict[@"category"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    return titleLabel;
    
}

@end
