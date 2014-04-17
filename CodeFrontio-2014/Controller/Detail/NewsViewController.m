//
//  NewsViewController.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 16/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Manager
#import "Manager.h"

#pragma mark Model
#import "News.h"

#pragma mark View
#import "NewsCell.h"

#pragma mark Controller
#import "NewsViewController.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface NewsViewController ()

@property (nonatomic) NSArray *news;

@property (nonatomic) NSMutableDictionary *rowHeights;

@end

@implementation NewsViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"News", nil);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Get news
    self.news = [Manager sharedManager].news;
    
    [self.tableView reloadData];
    
}

#pragma mark - Getter
- (NSMutableDictionary *)rowHeights {
    if (!_rowHeights) {
        _rowHeights = [NSMutableDictionary dictionary];
    }
    return _rowHeights;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.news.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    
    News *news = self.news[indexPath.row];
    
    NSString *htmlString = [NSString stringWithFormat:@"<div style='font-size:16px; font-family:HelveticaNeue-Light;'>%@</div>", news.detail];
    
    cell.textView.attributedText = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                         documentAttributes:nil
                                                                      error:nil];
    
    cell.detailLabel.text = news.date;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = [self.rowHeights[@(indexPath.row)] doubleValue];
    
    if (height != 0)
        return height;
    
    News *news = self.news[indexPath.row];
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"<.*?>" options:0 error:nil];
    NSString *string = [regularExpression stringByReplacingMatchesInString:news.detail options:0 range:NSMakeRange(0, news.detail.length) withTemplate:@""];
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.frame) - 30.0, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]}
                                       context:nil].size;
    
    if (ceil(size.height) > 40.0)
        height = tableView.rowHeight + ceil(size.height) - 40.0;
    else
        height = tableView.rowHeight;
    
    // Cache the calculated height
    self.rowHeights[@(indexPath.row)] = @(height);
    
    return height;
    
}

@end
