//
//  BaseViewController.m
//  CodeFrontio-2014
//
//  Created by Ilter Cengiz on 03/04/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "BaseViewController.h"

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
    
    [self setRevealWidth:240.0 forDirection:MSDynamicsDrawerDirectionLeft];
    
    UIViewController *masterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    UIViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    [self setDrawerViewController:masterViewController forDirection:MSDynamicsDrawerDirectionLeft];
    [self setPaneViewController:detailViewController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
