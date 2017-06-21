//
//  ViewController.m
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import "ViewController.h"
#import "AdManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self myTimerAction];
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    //How often to update the clock labels
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(myTimerAction) userInfo:nil repeats:YES];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
    [runloop addTimer:timer forMode:UITrackingRunLoopMode];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view addSubview:[AdManager shardAdBannerView]];

    //This is what sets the custom font
    self.hour1Label.font = [UIFont fontWithName:@"Molot" size:80];
    self.minute1Label.font = [UIFont fontWithName:@"Molot" size:80];
    self.hour2Label.font = [UIFont fontWithName:@"Molot" size:80];
    self.minute2Label.font = [UIFont fontWithName:@"Molot" size:80];
    self.colon1.font = [UIFont fontWithName:@"Molot" size:70];

    [super viewWillAppear:animated];
}

-(void)myTimerAction
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *hourMinuteSecond = [dateFormatter stringFromDate:date];
    
    self.hour1Label.text = [hourMinuteSecond substringWithRange:NSMakeRange(0, 1)];
    self.hour2Label.text = [hourMinuteSecond substringWithRange:NSMakeRange(1, 1)];
    self.minute1Label.text = [hourMinuteSecond substringWithRange:NSMakeRange(3, 1)];
    self.minute2Label.text = [hourMinuteSecond substringWithRange:NSMakeRange(4, 1)];
    self.colon1.text = ([self.colon1.text isEqualToString:@":"])?@" ":@":";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
