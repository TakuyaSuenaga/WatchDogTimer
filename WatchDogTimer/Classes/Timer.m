//
//  Timer.m
//  WatchdogTimer
//
//  Created by Takuya Suenaga on 2014/05/17.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import "Timer.h"

@implementation Timer

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.date forKey:@"timeToSetOff"];
    [encoder encodeInt:self.days forKey:@"days"];
    [encoder encodeInt:self.soundIndex forKey:@"soundIndex"];
    [encoder encodeBool:self.enabled forKey:@"enabled"];
    [encoder encodeInt:self.notificationID forKey:@"notificationID"];
}

//This is important to for loading the alarm object from user defaults
-(id)initWithCoder:(NSCoder *)decoder
{
    self.date = [decoder decodeObjectForKey:@"timeToSetOff"];
    self.days = [decoder decodeIntForKey:@"days"];
    self.soundIndex = [decoder decodeIntForKey:@"soundIndex"];
    self.enabled = [decoder decodeBoolForKey:@"enabled"];
    self.notificationID = [decoder decodeIntForKey:@"notificationID"];
    return self;
}

- (id)initWithDate:(NSDate*)date days:(int)days soundIndex:(int)soundIndex
{
    if (self = [super init]) {
        self.date = date;
        self.days = days;
        self.soundIndex = soundIndex;
        self.enabled = YES;
        self.notificationID = [self getUniqueNotificationID];
    }
    return self;
}

- (int)getUniqueNotificationID
{
//    NSMutableDictionary * hashDict = [[NSMutableDictionary alloc]init];
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *eventArray = [app scheduledLocalNotifications];
//
//    for (int i = 0; i < [eventArray count]; i++)
//    {
//        UILocalNotification *oneEvent = [eventArray objectAtIndex:i];
//        NSDictionary *userInfoCurrent = oneEvent.userInfo;
//        NSNumber *uid= [userInfoCurrent valueForKey:@"notificationID"];
//        NSNumber *value =[NSNumber numberWithInt:1];
//        [hashDict setObject:value forKey:uid];
//    }
//    for (int i = 0; i < [eventArray count]+1; i++)
//    {
//        NSNumber *value = [hashDict objectForKey:[NSNumber numberWithInt:i]];
//        if(!value)
//        {
//            return i;
//        }
//    }

    return 0;
}

+ (id)listWithDate:(NSDate*)date days:(int)days soundIndex:(int)soundIndex
{
    return [[Timer alloc] initWithDate:date days:days soundIndex:soundIndex];
}

@end
