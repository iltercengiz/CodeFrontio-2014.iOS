//
//  TrackCell.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 06/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Categories
#import "UIColor+Palette.h"

#pragma mark Model
#import "Session.h"
#import "Speaker.h"

#pragma mark View
#import "TrackCell.h"
#import "SessionCell.h"
#import "SessionCellDouble.h"
#import "ActivityCell.h"

#pragma mark Constants
#import "Constants.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface TrackCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *sessions;

@property (nonatomic) NSMutableDictionary *rowHeights;

@end

@implementation TrackCell

#pragma mark - NSObject UIKit Additions
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.trackLabel.backgroundColor = [UIColor whiteColor];
    self.trackLabel.textColor = [UIColor P_blueColor];
    self.trackLabel.layer.cornerRadius = 8.0;
    self.trackLabel.layer.borderColor = [UIColor P_lightBlueColor].CGColor;
    self.trackLabel.layer.borderWidth = 1.0;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(30.0, 0.0, 0.0, 0.0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), 10.0)];
    self.tableView.scrollsToTop = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SessionCell" bundle:nil] forCellReuseIdentifier:@"sessionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SessionCellDouble" bundle:nil] forCellReuseIdentifier:@"sessionCellDouble"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:@"activityCell"];
    
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
    
    Session *session = [sessions firstObject];
    self.trackLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Track %@", nil), session.track];
    
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
    
    SessionCell *(^getSessionCell)(Session *session, NSIndexPath *indexPath) = ^SessionCell *(Session *session, NSIndexPath *indexPath) {
        SessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell" forIndexPath:indexPath];
        [cell configureCellForSession:session];
        return cell;
    };
    
    SessionCellDouble *(^getSessionCellDouble)(Session *session, NSIndexPath *indexPath) = ^SessionCellDouble *(Session *session, NSIndexPath *indexPath) {
        SessionCellDouble *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCellDouble" forIndexPath:indexPath];
        [cell configureCellForSession:session];
        return cell;
    };
    
    ActivityCell *(^getActivityCell)(Session *session, NSIndexPath *indexPath) = ^ActivityCell *(Session *session, NSIndexPath *indexPath) {
        ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
        [cell configureCellForSession:session];
        return cell;
    };
    
    Session *session = self.sessions[indexPath.section];
    
    if ([session.speakerIdentifier isKindOfClass:[NSNumber class]])
        return getSessionCell(session, indexPath);
    else if ([session.speakerIdentifier isKindOfClass:[NSArray class]])
        return getSessionCellDouble(session, indexPath);
    else
        return getActivityCell(session, indexPath);
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Session *session = self.sessions[indexPath.section];
    
    if (!session.speakerIdentifier) {
        return 64.0;
    }
    
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
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:session.title
                                                                attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]}];
    NSAttributedString *detail;
    if (session.detail) {
        detail = [[NSAttributedString alloc] initWithString:session.detail
                                                 attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]}];
    }
    
    NSMutableAttributedString *mutableAttributedString = [NSMutableAttributedString new];
    [mutableAttributedString appendAttributedString:title];
    [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    if (detail) {
        [mutableAttributedString appendAttributedString:detail];
    }
    
    CGSize size = [mutableAttributedString boundingRectWithSize:desiredSize
                                                        options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                        context:nil].size;
    
    if (ceil(size.height) > 32.0) {
        height = tableView.rowHeight + ceil(size.height) - 32.0;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), self.tableView.sectionHeaderHeight)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

@end
