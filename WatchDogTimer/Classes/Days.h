//
//  Days.h
//  WatchdogTimer
//
//  Created by Takuya Suenaga on 2014/05/18.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    REPEAT_EVERY_SUNDAY     = 1 << 0,
    REPEAT_EVERY_MONDAY     = 1 << 1,
    REPEAT_EVERY_TUESDAY    = 1 << 2,
    REPEAT_EVERY_WEDNESDAY  = 1 << 3,
    REPEAT_EVERY_THURSDAY   = 1 << 4,
    REPEAT_EVERY_FRIDAY     = 1 << 5,
    REPEAT_EVERY_SATURDAY   = 1 << 6,
} Repeat_Days;

#define REPEAT_WEEKDAY  REPEAT_EVERY_MONDAY|REPEAT_EVERY_TUESDAY|REPEAT_EVERY_WEDNESDAY|REPEAT_EVERY_THURSDAY|REPEAT_EVERY_FRIDAY
#define REPEAT_WEEKEND  REPEAT_EVERY_SATURDAY|REPEAT_EVERY_SUNDAY
#define REPEAT_EVERYDAY REPEAT_WEEKDAY|REPEAT_WEEKEND

@interface Days : NSObject

+ (NSString*)daysToString:(int)days;

@end
