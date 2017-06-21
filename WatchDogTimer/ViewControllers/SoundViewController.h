//
//  SoundViewController.h
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/24.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SoundViewController;

@protocol SoundViewControllerDelegate
- (void)soundViewControllerDidFinish:(SoundViewController *)controller;
- (void)soundViewControllerDidCancel:(SoundViewController *)controller;
@end

@interface SoundViewController : UITableViewController

@property (weak, nonatomic) id <SoundViewControllerDelegate> delegate;
@property (nonatomic) int soundIndex;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
