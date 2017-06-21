//
//  Timer.h
//  WatchdogTimer
//
//  Created by Takuya Suenaga on 2014/05/17.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject <NSCoding>

@property (nonatomic) NSDate *date;
@property (nonatomic) int days;
@property (nonatomic) int soundIndex;
@property (nonatomic) BOOL enabled;
@property (nonatomic) int notificationID;

- (id)initWithDate:(NSDate*)date days:(int)days soundIndex:(int)soundIndex;
- (int)getUniqueNotificationID;
+ (id)listWithDate:(NSDate*)date days:(int)days soundIndex:(int)soundIndex;

@end
