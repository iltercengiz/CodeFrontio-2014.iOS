//
//  Note.h
//  Linz
//
//  Created by Ilter Cengiz on 18/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * sessionIdentifier;

@end
