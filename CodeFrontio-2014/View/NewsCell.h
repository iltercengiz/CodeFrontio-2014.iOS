//
//  NewsCell.h
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 17/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
