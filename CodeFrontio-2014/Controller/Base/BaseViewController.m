//
//  BaseViewController.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 03/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#pragma mark Controller
#import "BaseViewController.h"
#import "MasterViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - UIViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Set background color
    self.view.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.992 alpha:1];
    
    // Side menu stuff
    [self setRevealWidth:240.0 forDirection:MSDynamicsDrawerDirectionLeft];
    [self setGravityMagnitude:4.0];
    
    // Add stylers
    [self addStylersFromArray:@[[MSDynamicsDrawerShadowStyler styler],
                                [MSDynamicsDrawerResizeStyler styler],
                                [MSDynamicsDrawerScaleStyler styler],
                                [MSDynamicsDrawerFadeStyler styler],
                                [MSDynamicsDrawerParallaxStyler styler]
                                ]
                 forDirection:MSDynamicsDrawerDirectionLeft];
    
    MasterViewController *masterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    [self setDrawerViewController:masterViewController forDirection:MSDynamicsDrawerDirectionLeft];
    
    [masterViewController setBaseViewController:self];
    [masterViewController presentContentWithType:0 animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
