//
//  Sound.h
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/24.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import <Foundation/Foundation.h>

enum SoundIndex {
    Sound_Default = 0,
    Sound_Alarm,
    Sound_Japanese,
    Sound_Morning,
    Sound_Notification,
    Sound_Something,
};

@interface Sound : NSObject

+ (NSString *)getSoundFileName:(int)soundIndex;
+ (NSString *)getSoundName:(int)soundIndex;
+ (void)playSound:(int)soundIndex;
+ (void)stopSound;

@end
