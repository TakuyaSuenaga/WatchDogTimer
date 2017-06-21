//
//  SettingsViewController.h
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)back:(id)sender;

@end
