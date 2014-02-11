//
//  CalendarViewController.m
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark - Controller
#import "CalendarViewController.h"

#pragma mark - Libraries
#import "RFQuiltLayout.h"

@interface CalendarViewController () <RFQuiltLayoutDelegate>

@end

@implementation CalendarViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    RFQuiltLayout *layout = (RFQuiltLayout *)self.collectionView.collectionViewLayout;
    layout.delegate = self;
    layout.blockPixels = CGSizeMake(256.0, 64.0);
    layout.direction = UICollectionViewScrollDirectionHorizontal;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewControllerDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 33;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier;
    
    if (indexPath.item % 3 == 0) {
        identifier = @"TimeCell";
    } else {
        identifier = @"SessionCell";
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.item % 3 == 0) {
        cell.backgroundColor = [UIColor grayColor];
    } else {
        cell.backgroundColor = [UIColor greenColor];
    }
    
    return cell;
    
}

#pragma mark - UICollectionViewControllerDelegate


#pragma mark - RFQuiltLayoutDelegate
- (CGSize)blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item % 3 == 0) {
        return (CGSize){.width = 1.0, .height = 1.0};
    } else {
        return (CGSize){.width = 1.0, .height = 5.0};
    }
}

@end
