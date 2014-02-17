//
//  Sponsor.h
//  Linz
//
//  Created by Ilter Cengiz on 17/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sponsor : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSNumber * subpriority;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * websiteURL;
@property (nonatomic, retain) NSNumber * identifier;

@end
