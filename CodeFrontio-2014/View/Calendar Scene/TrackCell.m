//
//  TrackCell.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 06/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "TrackCell.h"

@interface TrackCell () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TrackCell

#pragma mark - UICollectionReusableView
- (void)prepareForReuse {
    
    NSLog(@"prepareForReuse is called!");
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), 10.0)];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), self.tableView.sectionHeaderHeight)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

@end
