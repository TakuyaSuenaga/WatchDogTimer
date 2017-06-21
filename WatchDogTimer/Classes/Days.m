//
//  Days.m
//  WatchdogTimer
//
//  Created by Takuya Suenaga on 2014/05/18.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import "Days.h"

@implementation Days

+ (NSString*)daysToString:(int)days
{
    NSString *ret = NSLocalizedString(@"None", nil);
    
    if (days) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        int Everyday = REPEAT_EVERYDAY;
        int Weekday  = REPEAT_WEEKDAY;
        int Weekend  = REPEAT_WEEKEND;
        int checkEveryday = days & Everyday;
        int checkWeekday  = days & Weekday;
        int checkWeekend  = days & Weekend;

        if (checkEveryday == Everyday) {
            [array addObject:NSLocalizedString(@"Everyday", nil)];
        } else if (checkWeekday == Weekday) {
            [array addObject:NSLocalizedString(@"Weekday", nil)];
            if (days & REPEAT_EVERY_SUNDAY)     [array addObject:NSLocalizedString(@"Sun", nil)];
            if (days & REPEAT_EVERY_SATURDAY)   [array addObject:NSLocalizedString(@"Sat", nil)];
        } else if (checkWeekend == Weekend) {
            [array addObject:NSLocalizedString(@"Weekend", nil)];
            if (days & REPEAT_EVERY_MONDAY)     [array addObject:NSLocalizedString(@"Mon", nil)];
            if (days & REPEAT_EVERY_TUESDAY)    [array addObject:NSLocalizedString(@"Tue", nil)];
            if (days & REPEAT_EVERY_WEDNESDAY)  [array addObject:NSLocalizedString(@"Wed", nil)];
            if (days & REPEAT_EVERY_THURSDAY)   [array addObject:NSLocalizedString(@"Thu", nil)];
            if (days & REPEAT_EVERY_FRIDAY)     [array addObject:NSLocalizedString(@"Fri", nil)];
        } else {
            if (days & REPEAT_EVERY_SUNDAY)     [array addObject:NSLocalizedString(@"Sun", nil)];
            if (days & REPEAT_EVERY_MONDAY)     [array addObject:NSLocalizedString(@"Mon", nil)];
            if (days & REPEAT_EVERY_TUESDAY)    [array addObject:NSLocalizedString(@"Tue", nil)];
            if (days & REPEAT_EVERY_WEDNESDAY)  [array addObject:NSLocalizedString(@"Wed", nil)];
            if (days & REPEAT_EVERY_THURSDAY)   [array addObject:NSLocalizedString(@"Thu", nil)];
            if (days & REPEAT_EVERY_FRIDAY)     [array addObject:NSLocalizedString(@"Fri", nil)];
            if (days & REPEAT_EVERY_SATURDAY)   [array addObject:NSLocalizedString(@"Sat", nil)];
        }
        ret = [array objectAtIndex:0];
        [array removeObjectAtIndex:0];
        for (NSString *string in array) {
            ret = [ret stringByAppendingString:[NSString stringWithFormat:@",%@", string]];
        }
    }

    return ret;
}

@end
