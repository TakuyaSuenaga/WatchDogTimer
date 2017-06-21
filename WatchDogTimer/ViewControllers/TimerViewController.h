//
//  TimerViewController.h
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *timerList;

- (IBAction)back:(id)sender;

@end
