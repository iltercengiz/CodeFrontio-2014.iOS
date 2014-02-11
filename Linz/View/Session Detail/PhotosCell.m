//
//  PhotosCell.m
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark View
#import "PhotosCell.h"
#import "PhotoCell.h"

@interface PhotosCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSArray *photos;

@end

@implementation PhotosCell

#pragma mark - Configurator
- (void)configureCellForPhotos:(NSArray *)photos {
    
    self.photos = photos;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *(^createPhotoCell)() = ^PhotoCell *(){
        PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
        [cell configureCellForPhoto:self.photos[indexPath.item]];
        return cell;
    };
    
    UICollectionViewCell *(^createAddPhotoCell)() = ^UICollectionViewCell *(){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addPhotoCell" forIndexPath:indexPath];
        return cell;
    };
    
    if (indexPath.item < self.photos.count) {
        return createPhotoCell();
    } else {
        return createAddPhotoCell();
    }
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Photo selected!");
}

@end
