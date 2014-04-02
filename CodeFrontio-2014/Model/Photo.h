//
//  Photo.h
//  Linz
//
//  Created by Ilter Cengiz on 19/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSNumber * sessionIdentifier;
@property (nonatomic, retain) NSNumber * identifier;

@end
