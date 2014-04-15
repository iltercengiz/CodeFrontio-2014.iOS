//
//  SocialCell.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 14/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Speaker.h"

#pragma mark View
#import "SocialCell.h"

@interface SocialCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSMutableArray *profiles;

@end

@implementation SocialCell

#pragma mark - NSObject UIKit Additions
- (void)awakeFromNib {
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
}

#pragma mark - UICollectionViewCell
- (void)prepareForReuse {
    self.profiles = nil;
    [self.collectionView reloadData];
}

#pragma mark - SocialCell
- (void)configureCellForSpeaker:(Speaker *)speaker {
    
    self.speaker = speaker;
    
    if (speaker.twitter)
        [self.profiles addObject:@(Twitter)];

    if (speaker.github)
        [self.profiles addObject:@(GitHub)];

    if (speaker.dribbble)
        [self.profiles addObject:@(Dribbble)];
    
    [self.collectionView reloadData];
    
}

#pragma mark - Getter
- (NSMutableArray *)profiles {
    if (!_profiles) {
        _profiles = [NSMutableArray array];
    }
    return _profiles;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.profiles.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"socialCell" forIndexPath:indexPath];
    
    ProfileType type = [self.profiles[indexPath.item] unsignedIntegerValue];
    
    switch (type) {
        case Twitter: cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Twitter"]]; break;
        case GitHub: cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GitHub"]]; break;
        case Dribbble: cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dribbble"]]; break;
        default: break;
    }
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
