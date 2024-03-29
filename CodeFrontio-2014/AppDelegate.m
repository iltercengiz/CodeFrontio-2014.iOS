//
//  AppDelegate.m
//  Linz
//
//  Created by Ilter Cengiz on 10/02/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "AppDelegate.h"

#pragma mark Categories
#import "UIImage+FromUIColor.h"

#pragma mark Pods
#import <MagicalRecord/CoreData+MagicalRecord.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    
/*
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (id)navigationController.topViewController;
 */
    
    /*** Database setup ***/
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    /*** UI Customization ***/
    [self customize];
    
    // A workaround to prevent the lag of keyboard
    // Keyboard blocks the UI for 3-4 seconds at the very first time it will be visible
    // This workaround extends the general loading time of the app, presenting the launch image for longer to the user
    // But it enables UI to be butter like smooth
    // Thanks to @Vadoff for his answer here: http://stackoverflow.com/a/20436797/1931781
    UITextField *lagFreeField = [UITextField new];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
    
    return YES;
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    /*** UI Customization ***/
    [self customize];
    
}
- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    /*** Database stuff ***/
    [MagicalRecord cleanUp];
    
}

#pragma mark - UI Customization
- (void)customize {
    
    // UINavigationBar coloring
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithUIColor:[UIColor colorWithRed:0.125 green:0.306 blue:0.576 alpha:1]]
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0],
                                                           NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    // UIToolbar
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageWithUIColor:[UIColor colorWithRed:0.255 green:0.255 blue:0.259 alpha:1]]
                            forToolbarPosition:UIBarPositionAny
                                    barMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
    
    // Change style of status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Re-enable status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}

@end
