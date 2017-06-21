//
//  TimerEditViewController.h
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZFlatUI.h"
#import "Timer.h"

@class TimerEditViewController;

@protocol TimerEditViewControllerDelegate
- (void)timerEditViewControllerDidFinish:(TimerEditViewController *)controller;
- (void)timerEditViewControllerDidCancel:(TimerEditViewController *)controller;
- (void)timerEditViewControllerDidRemove:(TimerEditViewController *)controller;
@end

@interface TimerEditViewController : UITableViewController

@property (weak, nonatomic) id <TimerEditViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *repeatDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *soundDetailLabel;
@property (weak, nonatomic) IBOutlet FUIButton *removeButton;

@property (nonatomic) Timer *timer;
@property (nonatomic) int days;
@property (nonatomic) int soundIndex;
@property (nonatomic) BOOL editMode;
@property (nonatomic) NSInteger indexOfAlarmToEdit;

- (IBAction)save:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)cancel:(id)sender;

@end
