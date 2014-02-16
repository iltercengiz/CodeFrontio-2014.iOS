//
//  Session.h
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Speaker;

@interface Session : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * track;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * timeInterval;
@property (nonatomic, retain) Speaker *speaker;

@end
