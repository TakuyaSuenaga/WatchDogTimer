//
//  RepeatViewController.m
//  WatchdogTimer
//
//  Created by Takuya Suenaga on 2014/05/18.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import "RepeatViewController.h"
#import "Days.h"
#import "InsetCell.h"

@interface RepeatViewController ()

@end

@implementation RepeatViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

const int daysArray[] = {REPEAT_EVERY_SUNDAY, REPEAT_EVERY_MONDAY, REPEAT_EVERY_TUESDAY, REPEAT_EVERY_WEDNESDAY, REPEAT_EVERY_THURSDAY, REPEAT_EVERY_FRIDAY, REPEAT_EVERY_SATURDAY};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_0_%d", (int)indexPath.row];
    InsetCell *cell = (InsetCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (self.days & daysArray[indexPath.row]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.days &= ~daysArray[indexPath.row];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.days |= daysArray[indexPath.row];
    }
}

- (IBAction)save:(id)sender {
    [self.delegate repeatViewControllerDidFinish:self];
}

- (IBAction)cancel:(id)sender {
    [self.delegate repeatViewControllerDidCancel:self];
}

@end
