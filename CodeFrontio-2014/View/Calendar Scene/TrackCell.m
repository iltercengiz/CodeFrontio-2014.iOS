//
//  TrackCell.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 06/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Session.h"

#pragma mark View
#import "TrackCell.h"
#import "SessionCell.h"

@interface TrackCell () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TrackCell

#pragma mark - NSObject UIKit Additions
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), 10.0)];
    [self.tableView registerNib:[UINib nibWithNibName:@"SessionCell" bundle:nil] forCellReuseIdentifier:@"sessionCell"];
    
}

#pragma mark - UICollectionReusableView
- (void)prepareForReuse {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sessions.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell" forIndexPath:indexPath];
    [cell configureCellForSession:self.sessions[indexPath.section]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Session *session = self.sessions[indexPath.section];
    
    CGSize size = [session.detail boundingRectWithSize:CGSizeMake(260.0, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0]}
                                               context:NULL].size;
    
    if (size.height > 128.0) {
        CGFloat height = tableView.rowHeight;
        height += size.height;
        height -= 128.0;
        return height;
    } else {
        return tableView.rowHeight;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableView:didSelectRowAtIndexPath: %@", indexPath);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), self.tableView.sectionHeaderHeight)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

@end
