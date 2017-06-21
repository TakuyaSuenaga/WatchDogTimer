//
//  TimerViewController.m
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import "TimerViewController.h"
#import "TimerEditViewController.h"
#import "Timer.h"
#import "Days.h"
#import "SZFlatUI.h"
#import "SZTwitter.h"
#import "SZLocalNotification.h"
#import "AdManager.h"

@interface TimerViewController () <TimerEditViewControllerDelegate>

@end

@implementation TimerViewController

@synthesize timerList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *timerData = [defaults objectForKey:@"TimerList"];
    timerList = [NSKeyedUnarchiver unarchiveObjectWithData:timerData];
    if (timerList == nil) {
        timerList = [[NSMutableArray alloc] init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return timerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimerCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Timer *timer = [timerList objectAtIndex:indexPath.section];

    UILabel *timeLabel = (UILabel *)[cell viewWithTag:1001];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    timeLabel.text = [dateFormatter stringFromDate:timer.date];
    timeLabel.font = [UIFont flatFontOfSize:timeLabel.font.pointSize];

    UILabel *repeatLabel = (UILabel *)[cell viewWithTag:1002];
    repeatLabel.text = [Days daysToString:timer.days];

    FUISwitch *fSwitch = [SZFlatUI makeSwitch];
    fSwitch.tag = indexPath.section;
    [fSwitch setOn:timer.enabled];
    [fSwitch addTarget:self action:@selector(timerSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = fSwitch;

    cell.tag = indexPath.section;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return 70;
        default: return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return [AdManager shardAdBannerView];
        default: return [[UIView alloc] initWithFrame:CGRectZero];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = (UITableViewCell*)sender;
    if ( [[segue identifier] isEqualToString:@"addTimer"] ) {
        [[segue destinationViewController] setDelegate:self];

        TimerEditViewController *vc = [segue destinationViewController];
        vc.timer = nil;
        vc.days = 0;
        vc.soundIndex = 0;
        vc.editMode = NO;
        vc.indexOfAlarmToEdit = 0;
    }
    else if ( [[segue identifier] isEqualToString:@"editTimer"] ) {
        [[segue destinationViewController] setDelegate:self];

        TimerEditViewController *vc = [segue destinationViewController];
        vc.timer = [self.timerList objectAtIndex:cell.tag];
        vc.days = vc.timer.days;
        vc.soundIndex = vc.timer.soundIndex;
        vc.editMode = YES;
        vc.indexOfAlarmToEdit = cell.tag;
    }
}

- (void)timerEditViewControllerDidFinish:(TimerEditViewController *)controller
{
    if (controller.editMode == NO) {
        if (controller.timer.enabled == YES) {
            if ([SZTwitter getTwitterOn] == NO) {
                [SZFlatUI showAlertViewWithTitle:NSLocalizedString(@"WARNING !", nil) message:NSLocalizedString(@"Please set up twitter on this app.", nil)];
                controller.timer.enabled = NO;
            }
        }
        [timerList addObject:controller.timer];
    }
    [self setTimerListToUserDefaults];
    [SZLocalNotification scheduleAllLocalNotifications];

    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}

- (void)timerEditViewControllerDidCancel:(TimerEditViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)timerEditViewControllerDidRemove:(TimerEditViewController *)controller
{
    if (controller.editMode == YES) {
        [timerList removeObjectAtIndex:controller.indexOfAlarmToEdit];
    }
    [self setTimerListToUserDefaults];
    [SZLocalNotification scheduleAllLocalNotifications];

    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}

- (void)wait:(float)time
{
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:time]];
}

- (void)setTimerListToUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"TimerList"];
    [defaults synchronize];
    NSData *timerData = [NSKeyedArchiver archivedDataWithRootObject:timerList];
    [defaults setObject:timerData forKey:@"TimerList"];
    [defaults synchronize];
}

#pragma mark - Action

- (void)timerSwitchChanged:(FUISwitch *)fSwitch {
    Timer *timer = [timerList objectAtIndex:fSwitch.tag];
    timer.enabled = fSwitch.on;
    [self setTimerListToUserDefaults];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if (fSwitch.on == YES) {
        if ([SZTwitter getTwitterOn] == NO) {
            [SZFlatUI showAlertViewWithTitle:NSLocalizedString(@"WARNING !", nil) message:NSLocalizedString(@"Please set up twitter on this app.", nil)];
            [fSwitch setOn:NO animated:YES];
            timer.enabled = NO;
            [self setTimerListToUserDefaults];
        } else {
            [SZLocalNotification scheduleAllLocalNotifications];
        }
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
