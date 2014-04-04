//
//  MasterViewHeader.m
//  Linz
//
//  Created by Ilter Cengiz on 20/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "MasterViewHeader.h"

@implementation MasterViewHeader

- (IBAction)kodioButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://codefront.io"]];
}
- (IBAction)webBoxButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://webbox.io"]];
}

@end
