//
//  DateFormatter.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 21/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "DateFormatter.h"

@interface DateFormatter ()

@property (nonatomic) NSDateFormatter *formatter;

@end

@implementation DateFormatter

+ (instancetype)sharedFormatter {
    static DateFormatter *_sharedFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFormatter = [DateFormatter new];
    });
    return _sharedFormatter;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [NSDateFormatter new];
        _formatter.timeStyle = NSDateFormatterShortStyle;
    }
    return _formatter;
}

- (NSString *)stringFromDate:(NSDate *)date {
    return [self.formatter stringFromDate:date];
}

@end
