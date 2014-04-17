//
//  PagerLayout.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 06/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

/**
 *
 * Credit: http://stackoverflow.com/a/22454509/1931781
 *
 */

#import "PagerLayout.h"

@implementation PagerLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    NSArray *layoutAttributesArray = [self layoutAttributesForElementsInRect:self.collectionView.bounds];
    
    if(layoutAttributesArray.count == 0)
        return proposedContentOffset;
    
    UICollectionViewLayoutAttributes *candidate = layoutAttributesArray.firstObject;
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesArray) {
        
        if (layoutAttributes.representedElementCategory != UICollectionElementCategoryCell)
            continue;
        
        if((velocity.x > 0.0 && layoutAttributes.center.x > candidate.center.x) ||
           (velocity.x < 0.0 && layoutAttributes.center.x < candidate.center.x))
        {
            candidate = layoutAttributes;
        } else if (velocity.x == 0.0) {
            if (layoutAttributes.center.x > proposedContentOffset.x + 15.0 &&
                layoutAttributes.center.x < proposedContentOffset.x + CGRectGetWidth(self.collectionView.frame) - 15.0)
            {
                candidate = layoutAttributes;
            }
        }
        
    }
    
    return CGPointMake(candidate.center.x - self.collectionView.bounds.size.width * 0.5f, proposedContentOffset.y);
    
}

@end
