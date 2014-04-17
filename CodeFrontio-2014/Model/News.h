//
//  News.h
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 17/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface News : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSNumber * identifier;

@end
