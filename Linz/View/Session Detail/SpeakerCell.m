//
//  SpeakerCell.m
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "SpeakerCell.h"

@implementation SpeakerCell

#pragma mark - Configurator
- (void)configureCellForSpeaker:(NSDictionary *)speaker {
    
    self.imageView.image = [UIImage imageNamed:@"kod-io-logo-black"];
    self.textLabel.text = @"Kod.io rocx!!!1";
    
}

@end
