//
//  SZLocalNotification.h
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZLocalNotification : NSObject

+ (void)scheduleAllLocalNotifications;
+ (void)configureNotificationWithDate:(NSDate*)date soundName:(NSString*)soundName;

@end
