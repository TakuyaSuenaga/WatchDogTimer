//
//  AppDelegate.m
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SZLocalNotification.h"

@implementation AppDelegate

- (void)setupWindow
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	ViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
	self.window.rootViewController = rootViewController;
	[self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    application.idleTimerDisabled = YES;
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        [application cancelLocalNotification:notification];
        [application cancelAllLocalNotifications] ;
        [SZLocalNotification scheduleAllLocalNotifications];
        [self setupWindow];
    }
    
    [application setApplicationIconBadgeNumber:0];
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [application setApplicationIconBadgeNumber:0];
    [application cancelLocalNotification:notification];
    [application cancelAllLocalNotifications] ;
    [SZLocalNotification scheduleAllLocalNotifications];
	[self setupWindow];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (application.applicationIconBadgeNumber == 0) {
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        self.twitter = [SZTwitter allocWithProperty];
        [self.twitter postDirectMessageOnTwitter:^(BOOL result, NSString *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result == FALSE) {
                    completionHandler(UIBackgroundFetchResultFailed);
                } else {
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                    completionHandler(UIBackgroundFetchResultNewData);
                }
            });
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Location Methods

//- (void)startMonitoringLocation {
//    if (self.locationManager == nil) {
//        self.locationManager = [[CLLocationManager alloc] init];
//    }
//    [self.locationManager setDelegate:self];
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [self.locationManager startMonitoringSignificantLocationChanges];
//}
//
//- (void)stopMonitoringLocation
//{
//    [self.locationManager stopUpdatingLocation];
//}
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    [manager stopMonitoringSignificantLocationChanges];
//    self.twitter.latitude  = [newLocation coordinate].latitude;
//    self.twitter.longitude = [newLocation coordinate].longitude;
//    DLog(@"didUpdateToLocation latitude=%f, longitude=%f, accuracy=%f, time=%@", [newLocation coordinate].latitude,
//         [newLocation coordinate].longitude, newLocation.horizontalAccuracy, newLocation.timestamp);
//    [self postTwitter];
//}
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    DLog(@"%s | %@", __PRETTY_FUNCTION__, error);
//    
//    if ([error code] == kCLErrorDenied) {
//        [manager stopMonitoringSignificantLocationChanges];
//    }
//    [self postTwitter];
//}

@end
