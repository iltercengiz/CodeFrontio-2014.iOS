//
//  SpeakerCell.h
//  Linz
//
//  Created by Ilter Cengiz on 12/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Speaker;

@interface SpeakerCell : UITableViewCell

#pragma mark - Configurator
- (void)configureCellForSpeaker:(Speaker *)speaker;

@end
