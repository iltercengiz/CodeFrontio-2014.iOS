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
    
    // Side menu width
    [self setRevealWidth:240.0 forDirection:MSDynamicsDrawerDirectionLeft];
    
    // Add stylers
    [self addStylersFromArray:@[[MSDynamicsDrawerShadowStyler styler],
                                [MSDynamicsDrawerResizeStyler styler],
                                [MSDynamicsDrawerScaleStyler styler],
                                [MSDynamicsDrawerFadeStyler styler],
                                [MSDynamicsDrawerParallaxStyler styler]
                                ]
                 forDirection:MSDynamicsDrawerDirectionLeft];
    
    MasterViewController *masterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    UIViewController *calendarViewController = [self.storyboard instantiateViewControllerWithIdentifier:calendarSceneIdentifier];
    UINavigationController *paneViewController = [[UINavigationController alloc] initWithRootViewController:calendarViewController];
    
    [self setDrawerViewController:masterViewController forDirection:MSDynamicsDrawerDirectionLeft];
    [self setPaneViewController:paneViewController];
    
    masterViewController.baseViewController = self;
    masterViewController.scenes[calendarSceneIdentifier] = paneViewController;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
