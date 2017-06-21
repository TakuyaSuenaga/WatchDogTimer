//
//  Sound.m
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/24.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

@import AVFoundation;

#import "Sound.h"

AVAudioPlayer *audio;

@implementation Sound

+ (NSString *)getSoundFileName:(int)soundIndex
{
    switch (soundIndex) {
        case Sound_Alarm:
            return @"alarm.mp3";
        case Sound_Japanese:
            return @"jingle_10.mp3";
        case Sound_Morning:
            return @"jingle_13.mp3";
        case Sound_Notification:
            return @"jingle_18.mp3";
        case Sound_Something:
            return @"jingle_20.mp3";
        case Sound_Default:
        default:
            return UILocalNotificationDefaultSoundName;
    }
}

+ (NSString *)getSoundName:(int)soundIndex
{
    switch (soundIndex) {
        case Sound_Alarm:
            return NSLocalizedString(@"Alarm", nil);
        case Sound_Japanese:
            return NSLocalizedString(@"Japanese", nil);
        case Sound_Morning:
            return NSLocalizedString(@"Morning", nil);
        case Sound_Notification:
            return NSLocalizedString(@"Notification", nil);
        case Sound_Something:
            return NSLocalizedString(@"Something", nil);
        case Sound_Default:
        default:
            return NSLocalizedString(@"Default", nil);
    }
}

+ (void)playSound:(int)soundIndex
{
    [audio stop];

    if (soundIndex == Sound_Default) {
        return;
    }
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *file = [Sound getSoundFileName:soundIndex];
    NSArray* items = [file componentsSeparatedByString:@"."];
    NSString *filePath = [mainBundle pathForResource:[items objectAtIndex:0] ofType:[items objectAtIndex:1]];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSError *error = nil;
    audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
    [audio play];
}

+ (void)stopSound
{
    [audio stop];
}

@end
