//
//  SpeakerViewController.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 14/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Speaker.h"

#pragma mark View
#import "AvatarView.h"
#import "SocialCell.h"

#pragma mark Controller
#import "SpeakerViewController.h"

@interface SpeakerViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSMutableArray *profiles;

@end

@implementation SpeakerViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = self.speaker.name;
    
    if (self.speaker.twitter && ![self.speaker.twitter isEqualToString:@""]) {
        [self.profiles addObject:@(Twitter)];
    }
    if (self.speaker.github && ![self.speaker.github isEqualToString:@""]) {
        [self.profiles addObject:@(GitHub)];
    }
    if (self.speaker.dribbble && ![self.speaker.dribbble isEqualToString:@""]) {
        [self.profiles addObject:@(Dribbble)];
    }
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.textView.text = self.speaker.detail;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    SocialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"socialCell" forIndexPath:indexPath];
    [cell configureCellForProfileType:[self.profiles[indexPath.item] unsignedIntegerValue]];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    AvatarView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"avatarView" forIndexPath:indexPath];
    [view configureViewForSpeaker:self.speaker];
    return view;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
