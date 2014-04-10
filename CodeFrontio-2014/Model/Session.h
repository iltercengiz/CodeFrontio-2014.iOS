//
//  Session.h
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 10/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Session : NSManagedObject

@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSNumber * favourited;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * speakerIdentifier;
@property (nonatomic, retain) NSNumber * timeInterval;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * track;
@property (nonatomic, retain) NSNumber * type;

@end
