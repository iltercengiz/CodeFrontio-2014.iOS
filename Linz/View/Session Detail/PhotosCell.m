//
//  PhotosCell.m
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Model
#import "Photo.h"
#import "Session.h"

#pragma mark View
#import "PhotosCell.h"
#import "PhotoCell.h"

#pragma mark Pods
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#import <CZPhotoPickerController/CZPhotoPickerController.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface PhotosCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSMutableArray *photos;
@property (nonatomic) NSNumber *sessionIdentifier;

@property (nonatomic) CZPhotoPickerController *picker;

@end

@implementation PhotosCell

#pragma mark - Configurator
- (void)configureCellForSession:(Session *)session andTableView:(UITableView *)tableView {
    
    // Assign the tableView
    self.tableView = tableView;
    
    // Get the session identifier to assign it to the photos taken
    self.sessionIdentifier = session.identifier;
    
    // Get photos for the given session
    self.photos = [[Photo MR_findAllSortedBy:@"identifier"
                                   ascending:YES
                               withPredicate:[NSPredicate predicateWithFormat:@"sessionIdentifier == %@", self.sessionIdentifier]] mutableCopy];
    
    // Set self as dataSource and delegate of the collection view
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
        
        // Photo entity
        Photo *photoEntity = self.photos[indexPath.item];
        
        // Get photo from disk
        NSInteger sessionIdentifier = self.sessionIdentifier.integerValue;
        NSInteger photoIdentifier = photoEntity.identifier.integerValue;
        
        NSString *photoPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Photo-%li-%li", (long)sessionIdentifier, (long)photoIdentifier]];
        
        UIImage *photo = [UIImage imageWithContentsOfFile:photoPath];
        
        // Configure cell for photo
        [cell configureCellForPhoto:photo];
        
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
    
    // The selected cell
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    // Check which cell is selected
    if (indexPath.item < self.photos.count) {
        
        // IDMPhotos
        NSArray *photos = [IDMPhoto photosWithImages:self.photos];
        
        // Browser object
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:cell];
        [browser setInitialPageIndex:indexPath.item];
        
        // Present browser
        id controller = self.tableView.dataSource;
        [controller presentViewController:browser animated:YES completion:nil];
        
    } else {
        
        // Weak reference to self
        __weak typeof(self) weakSelf = self;
        
        // Controller object
        id controller = self.tableView.dataSource;
        
        // Create picker and present it
        self.picker = [[CZPhotoPickerController alloc] initWithPresentingViewController:controller
                                                                    withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
                                                                        
                                                                        UIImage *photo = imageInfoDict[UIImagePickerControllerOriginalImage];
                                                                        
                                                                        if (photo) {
                                                                            
                                                                            // Identifiers
                                                                            NSInteger sessionIdentifier = self.sessionIdentifier.integerValue;
                                                                            NSInteger photoIdentifier = ((Photo *)[self.photos lastObject]).identifier.integerValue + 1;
                                                                            
                                                                            // Save photo to disk
                                                                            NSData *photoData = UIImageJPEGRepresentation(photo, 1);
                                                                            NSString *photoPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Photo-%li-%li", (long)sessionIdentifier, (long)photoIdentifier]];
                                                                            [photoData writeToFile:photoPath atomically:YES];
                                                                            
                                                                            // Create a photo object
                                                                            Photo *photoEntity = [Photo MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
                                                                            photoEntity.sessionIdentifier = @(sessionIdentifier);
                                                                            photoEntity.identifier = @(photoIdentifier);
                                                                            photoEntity.photoURL = photoPath;
                                                                            
                                                                            // Save db
                                                                            [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                                                                                if (success) NSLog(@"Save successful!");
                                                                                else NSLog(@"Save failed with error: %@", error);
                                                                            }];
                                                                            
                                                                            // Add photo to the array
                                                                            [self.photos addObject:photoEntity];
                                                                            
                                                                            // Reload collection view
                                                                            [self.collectionView reloadData];
                                                                            
                                                                        }
                                                                        
                                                                        [weakSelf.picker dismissAnimated:YES];
                                                                        weakSelf.picker = nil;
                                                                        
                                                                    }];
        self.picker.saveToCameraRoll = NO;
        [self.picker showFromRect:self.frame];
        
    }
    
}

@end
