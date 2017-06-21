//
//  TwitterViewController.h
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZFlatUI.h"

@interface TwitterViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *toTextField;
@property (strong, nonatomic) IBOutlet FUISwitch *locationSwitch;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet FUIButton *tweetButton;

- (IBAction)tweet:(id)sender;
- (IBAction)cancel:(id)sender;

@end
