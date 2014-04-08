//
//  Session+Create.h
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "Session.h"

@interface Session (Create)

+ (Session *)sessionWithInfo:(NSDictionary *)info track:(NSNumber *)trackNumber;

@end
