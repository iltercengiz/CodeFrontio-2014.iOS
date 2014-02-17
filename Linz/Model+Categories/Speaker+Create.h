//
//  Speaker+Create.h
//  Linz
//
//  Created by Ilter Cengiz on 16/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "Speaker.h"

@interface Speaker (Create)

+ (Speaker *)speakerWithInfo:(NSDictionary *)info;
+ (BOOL)removeAllSpeakers;

@end
