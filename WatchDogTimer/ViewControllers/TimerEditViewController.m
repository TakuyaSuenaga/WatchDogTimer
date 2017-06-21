//
//  TimerEditViewController.m
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import "TimerEditViewController.h"
#import "RepeatViewController.h"
#import "SoundViewController.h"
#import "Days.h"
#import "Sound.h"

@interface TimerEditViewController () <RepeatViewControllerDelegate, SoundViewControllerDelegate>

@end

@implementation TimerEditViewController

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

	self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"da_DK"];
    self.repeatDetailLabel.text = [Days daysToString:self.days];
    self.soundDetailLabel.text = [Sound getSoundName:self.soundIndex];
    
    if (self.editMode == YES) {
        self.datePicker.date = self.timer.date;
        [SZFlatUI makeCancelButton:self.removeButton WithTitle:NSLocalizedString(@"Remove Timer", nil)];
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
    if (self.editMode == YES) {
        return 3;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 1:
            return 2;
    }
    return 1;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"showRepeatView"] ) {
        [[segue destinationViewController] setDelegate:self];
        RepeatViewController *vc = [segue destinationViewController];
        vc.days = self.days;
    }
    if ( [[segue identifier] isEqualToString:@"showSoundView"] ) {
        [[segue destinationViewController] setDelegate:self];
        SoundViewController *vc = [segue destinationViewController];
        vc.soundIndex = self.soundIndex;
    }
}

- (void)repeatViewControllerDidFinish:(RepeatViewController *)controller
{
    self.days = controller.days;
    self.repeatDetailLabel.text = [Days daysToString:self.days];
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}

- (void)repeatViewControllerDidCancel:(RepeatViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)soundViewControllerDidFinish:(SoundViewController *)controller
{
    self.soundIndex = controller.soundIndex;
    self.soundDetailLabel.text = [Sound getSoundName:self.soundIndex];
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}

- (void)soundViewControllerDidCancel:(SoundViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    if (self.days == 0) {
        [SZFlatUI showAlertViewWithTitle:NSLocalizedString(@"WARNING !", nil)
                                 message:NSLocalizedString(@"Please input 'Repeat'", nil)];
        return;
    }
    
    NSDate *date = [self formatDateToTime:self.datePicker.date];
    if (self.editMode == NO) {
        self.timer = [Timer listWithDate:date days:self.days soundIndex:self.soundIndex];
    } else {
        self.timer.date = date;
        self.timer.days = self.days;
        self.timer.soundIndex = self.soundIndex;
    }
    [self.delegate timerEditViewControllerDidFinish:self];
}

- (IBAction)remove:(id)sender {
    [self.delegate timerEditViewControllerDidRemove:self];
}

- (IBAction)cancel:(id)sender {
    [self.delegate timerEditViewControllerDidCancel:self];
}

- (NSDate*)formatDateToTime:(NSDate*)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh-mm -a";
    NSDate *ret = [dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
    return ret;
}

@end
