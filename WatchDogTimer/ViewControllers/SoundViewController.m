//
//  SoundViewController.m
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/24.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import "SoundViewController.h"
#import "InsetCell.h"
#import "Sound.h"

#define numOfCells 6

@interface SoundViewController ()

@end

@implementation SoundViewController

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
    return numOfCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_0_%d", (int)indexPath.row];
    InsetCell *cell = (InsetCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row == self.soundIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (int i = 0; i < [self.tableView numberOfRowsInSection:indexPath.section]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.row == i) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.soundIndex = (int)indexPath.row;
            [Sound playSound:self.soundIndex];
        }
    }
}

- (IBAction)save:(id)sender {
    [Sound stopSound];
    [self.delegate soundViewControllerDidFinish:self];
}

- (IBAction)cancel:(id)sender {
    [Sound stopSound];
    [self.delegate soundViewControllerDidCancel:self];
}

@end
