//
//  AppDelegate.h
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

@import CoreLocation;

#import <UIKit/UIKit.h>
#import "SZTwitter.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) SZTwitter *twitter;
@property (nonatomic) CLLocationManager *locationManager;

@end
