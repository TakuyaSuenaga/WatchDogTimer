//
//  SZLocalNotification.m
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import "SZLocalNotification.h"
#import "Timer.h"
#import "NSDate+Extras.h"
#import "SZFlatUI.h"
#import "Sound.h"

@implementation SZLocalNotification

+ (void)scheduleAllLocalNotifications
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *timerData = [defaults objectForKey:@"TimerList"];
    NSMutableArray *timerList = [NSKeyedUnarchiver unarchiveObjectWithData:timerData];
    if (timerList == nil) {
        [SZFlatUI showAlertViewWithTitle:NSLocalizedString(@"WARNING !", nil) message:NSLocalizedString(@"Failed to schedule local notification.", nil)];
        return;
    }

    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    for (Timer *timer in timerList) {
        if (timer.enabled == YES) {
            NSArray *oneweekDate = [timer.date oneWeekDateWithEnableWeekdayType:timer.days];
            NSString *soundName = [Sound getSoundFileName:timer.soundIndex];
            // 取得した日付を順次ローカル通知に登録
            for (NSDate *date in oneweekDate) {
                [self configureNotificationWithDate:date soundName:soundName];
            }
        }
    }
}

+ (void)configureNotificationWithDate:(NSDate*)date soundName:(NSString*)soundName
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 通知する日付
    [notification setFireDate:date];
    // 使用するカレンダー
    notification.repeatCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    // 毎週繰り返す
    notification.repeatInterval = NSWeekCalendarUnit;
    // タイムゾーン
    [notification setTimeZone:[NSTimeZone localTimeZone]];
    // 通知する本文
    [notification setAlertBody:NSLocalizedString(@"Check", nil)];
    // 通知音(デフォルトを指定)
    [notification setSoundName:soundName];
    // アラートタイプ(ダイアログ)の通知の場合に使用する決定ボタンの文字列
    [notification setAlertAction:NSLocalizedString(@"Application Start", nil)];
    [notification setApplicationIconBadgeNumber:1];
    // ローカル通知の登録
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
