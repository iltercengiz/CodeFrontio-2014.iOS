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

@end
