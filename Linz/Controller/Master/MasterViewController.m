//
//  MasterViewController.m
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    
    // Set title
    switch (indexPath.row) {
        case 0: cell.textLabel.text = NSLocalizedString(@"Calendar", nil); break;
        case 1: cell.textLabel.text = NSLocalizedString(@"Favourites", nil); break;
        case 2: cell.textLabel.text = NSLocalizedString(@"Notes", nil); break;
        case 3: cell.textLabel.text = NSLocalizedString(@"Venue", nil); break;
        case 4: cell.textLabel.text = NSLocalizedString(@"Supporters", nil); break;
        default: break;
    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.frame), tableView.sectionHeaderHeight)];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kod-io-logo-black"]];
    
    // Adjust position of logo
    logo.frame = ({
        CGRect frame = logo.frame;
        frame.origin.x = (CGRectGetWidth(headerView.frame) - CGRectGetWidth(frame)) / 2.0;
        frame.origin.y = (CGRectGetHeight(headerView.frame) - CGRectGetHeight(frame)) / 2.0;
        frame;
    });
    
    // Add logo as subview
    [headerView addSubview:logo];
    
    return headerView;
    
}

@end
