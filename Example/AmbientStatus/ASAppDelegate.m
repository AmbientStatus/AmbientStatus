//
//  ASAppDelegate.m
//  AmbientStatus
//
//  Created by CocoaPods on 06/26/2014.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "ASAppDelegate.h"

@interface ASAppDelegate ()

@property (strong, nonatomic) ASBatteryMonitor *batteryMonitor;
@property (strong, nonatomic) ASTransitMonitor *transitMonitor;

@property (strong, nonatomic) ASViewController *viewController;

@end

@implementation ASAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.viewController = [[ASViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    self.window.rootViewController = navController;
    
    self.batteryMonitor = [ASBatteryMonitor sharedInstance];
    [self.batteryMonitor startMonitoring];
    
    self.transitMonitor = [ASTransitMonitor sharedInstance];
    [self.transitMonitor startMonitoring];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return true;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self checkBatteryState]; //Just to show that it can be accessed in background
    [self checkTransitState];
    
    [self.viewController.tableView reloadData];
    
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)checkBatteryState {
    NSLog(@"[ASBatteryMonitor] Current State: %@            Current Level: %@",[NSString batteryStateToString:self.batteryMonitor.state],
          [NSString floatToPercentString:self.batteryMonitor.percentage]);
}

- (void)checkTransitState {
    NSLog(@"[ASTransitMonitor] Current State: %@            Current Speed: %f",[NSString transitStateToString:self.transitMonitor.state], self.transitMonitor.speed);
}

@end
