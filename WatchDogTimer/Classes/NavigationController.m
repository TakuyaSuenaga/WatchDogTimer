//
//  NavigationController.m
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/05/28.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import "NavigationController.h"
#import "SZFlatUI.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SZFlatUI makeNavigationBar:self.navigationBar];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [UINavigationBar appearance].barTintColor = [UIColor midnightBlueColor];
//    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
