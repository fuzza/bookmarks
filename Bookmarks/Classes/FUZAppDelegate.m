//
//  AppDelegate.m
//  Bookmarks
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <SVProgressHUD.h>

#import "FUZAppDelegate.h"
#import "FUZCoreDataStack.h"
#import "FUZMapViewController.h"

@interface FUZAppDelegate ()

@property (strong, nonatomic) FUZCoreDataStack *persistenceStack;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation FUZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [SVProgressHUD setBackgroundColor:[UIColor lightGrayColor]];
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    FUZMapViewController *rootViewController = (FUZMapViewController *)[navigationController topViewController];

    self.persistenceStack = [[FUZCoreDataStack alloc] init];
    rootViewController.managedObjectContext = self.persistenceStack.managedObjectContext;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self.persistenceStack.managedObjectContext save:nil];
}

@end
