//
//  RepeatViewController.h
//  WatchdogTimer
//
//  Created by Takuya Suenaga on 2014/05/18.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RepeatViewController;

@protocol RepeatViewControllerDelegate
- (void)repeatViewControllerDidFinish:(RepeatViewController *)controller;
- (void)repeatViewControllerDidCancel:(RepeatViewController *)controller;
@end

@interface RepeatViewController : UITableViewController

@property (weak, nonatomic) id <RepeatViewControllerDelegate> delegate;
@property int days;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
