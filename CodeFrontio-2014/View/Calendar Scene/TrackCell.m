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

#pragma mark Constants
#import "Constants.h"

@interface TrackCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *sessions;

@property (nonatomic) NSMutableDictionary *rowHeights;

@end

@implementation TrackCell

#pragma mark - NSObject UIKit Additions
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), 10.0)];
    [self.tableView registerNib:[UINib nibWithNibName:@"SessionCell" bundle:nil] forCellReuseIdentifier:@"sessionCell"];
    
}

#pragma mark - Getter
- (NSMutableDictionary *)rowHeights {
    if (!_rowHeights) {
        _rowHeights = [NSMutableDictionary dictionary];
    }
    return _rowHeights;
}

#pragma mark - TrackCell
- (void)configureCellForSessions:(NSArray *)sessions {
    
    self.sessions = sessions;
    
    [self.tableView reloadData];
    
}

#pragma mark - UICollectionReusableView
- (void)prepareForReuse {
    self.sessions = nil;
    self.rowHeights = nil;
    [self.tableView scrollRectToVisible:(CGRect){.origin = CGPointZero, .size = CGSizeMake(1.0, 1.0)} animated:NO];
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
    
    CGFloat height = [self.rowHeights[session.track][@(indexPath.section)] doubleValue];
    
    if (height != 0) {
        return height;
    }
    
    CGSize desiredSize = CGSizeZero;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        desiredSize = CGSizeMake(300.0, CGFLOAT_MAX);
    } else { // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        desiredSize = CGSizeMake(260.0, CGFLOAT_MAX);
    }
    
    CGSize size = [session.detail boundingRectWithSize:desiredSize
                                               options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0]}
                                               context:NULL].size;
    
    if (ceil(size.height) > 87.0) {
        height = tableView.rowHeight + ceil(size.height) - 87.0;
    } else {
        height = tableView.rowHeight;
    }
    
    NSMutableDictionary *rowHeightsOfTrack = self.rowHeights[session.track];
    if (!rowHeightsOfTrack) {
        rowHeightsOfTrack = [NSMutableDictionary dictionary];
        self.rowHeights[session.track] = rowHeightsOfTrack;
    }
    rowHeightsOfTrack[@(indexPath.section)] = @(height);
    
    return height;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:didSelectSessionNotification object:nil userInfo:@{@"session": self.sessions[indexPath.section]}];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), self.tableView.sectionHeaderHeight)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

@end
