//
//  TwitterViewController.m
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

@import CoreLocation;

#import "TwitterViewController.h"
#import "InsetCell.h"
#import "SZTwitter.h"
#import "SVProgressHUD.h"
#import "PHFComposeBarView.h"

@interface TwitterViewController () <UITextFieldDelegate, PHFComposeBarViewDelegate, CLLocationManagerDelegate>

@property (nonatomic) NSMutableArray *twitterUsers;
@property (nonatomic) SZTwitter *twitter;
@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation TwitterViewController
{
    PHFComposeBarView *myComposeBarView;
}

@synthesize tweetButton, twitter, twitterUsers;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];

    twitter = [SZTwitter allocWithProperty];
    [twitter getTwitterAccountOnCompletion:^(NSMutableArray *users) {
        self.twitterUsers = users;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tweet:(id)sender
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Sending ...", nil) maskType:SVProgressHUDMaskTypeBlack];
    [twitter postDirectMessageOnTwitter:^(BOOL result, NSString *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (result == FALSE) {
                [SZFlatUI showAlertViewWithTitle:NSLocalizedString(@"FAILED !", nil)
                                         message:[NSString stringWithFormat:NSLocalizedString(@"You've just failed posting to twitter because of [%@].", nil), error]];
                [SZTwitter setTwitterOn:NO];
            } else {
                [SZFlatUI showAlertViewWithTitle:NSLocalizedString(@"SUCCESS !", nil)
                                         message:NSLocalizedString(@"You've just succeeded posting to twitter.", nil)];
                [twitter saveProperty];
                [SZTwitter setTwitterOn:YES];
            }
        });
    }];
}

- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)timerSwitchChanged:(FUISwitch *)fSwitch {
    [fSwitch setOn:fSwitch.on animated:YES];
    [SZTwitter setLocationOn:fSwitch.on];
    if (fSwitch.on == YES) {
        [self startMonitoringLocation];
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark - Location Methods

- (void)startMonitoringLocation {
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    [self.locationManager setDelegate:self];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)stopMonitoringLocation
{
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopMonitoringSignificantLocationChanges];
    twitter.latitude  = [newLocation coordinate].latitude;
    twitter.longitude = [newLocation coordinate].longitude;
    DLog(@"didUpdateToLocation latitude=%f, longitude=%f, accuracy=%f, time=%@", [newLocation coordinate].latitude,
         [newLocation coordinate].longitude, newLocation.horizontalAccuracy, newLocation.timestamp);
    [self.tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopMonitoringSignificantLocationChanges];
    CLLocation* location = [locations lastObject];
    twitter.latitude  = location.coordinate.latitude;
    twitter.longitude = location.coordinate.longitude;
    DLog(@"didUpdateToLocation latitude=%f, longitude=%f, accuracy=%f, time=%@", twitter.latitude,
         twitter.longitude, location.horizontalAccuracy, location.timestamp);
    [self.tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DLog(@"%s | %@", __PRETTY_FUNCTION__, error);
    
    if ([error code] == kCLErrorDenied) {
        [manager stopMonitoringSignificantLocationChanges];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return twitterUsers.count;
//        case 2:
//            return 2;
        default:
            return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Please select account";
        case 1:
            return @"Please write recipient username";
        case 2:
            return @"Message";
        case 3:
            return @" ";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 2:
            switch (indexPath.row) {
                case 0: {
//                    return 0;
//                }
//                case 1: {
                    NSString *text = [twitter createMessage];
                    CGRect rect = [text boundingRectWithSize:CGSizeMake(240, MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont flatFontOfSize:14]}
                                                     context:nil];
                    float h = rect.size.height - 38;
                    if (h > 0) {
                        return 44 + h;
                    }
                    break;
                }
            }
            break;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"Cell_%ld_%ld", (long)indexPath.section, (long)indexPath.row];
    if (indexPath.section == 0) {
        identifier = @"Cell_Username";
    }
    InsetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [twitterUsers objectAtIndex:indexPath.row];
            if ([cell.textLabel.text isEqualToString:twitter.username]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    self.toTextField = (UITextField*)[cell viewWithTag:2];
                    self.toTextField.leftView = [SZFlatUI makeLabelWithFrame:CGRectMake(0, 0, 20, 20) text:@"@" size:17];
                    self.toTextField.leftViewMode = UITextFieldViewModeAlways;
                    self.toTextField.text = twitter.toAddress;
                    self.toTextField.font = [UIFont flatFontOfSize:17];
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
//                    self.locationSwitch = [SZFlatUI makeSwitch];
//                    [self.locationSwitch addTarget:self action:@selector(timerSwitchChanged:) forControlEvents:UIControlEventValueChanged];
//                    self.locationSwitch.on = [SZTwitter getLocationOn];
//                    cell.accessoryView = self.locationSwitch;
//                    break;
//                case 1:
                    cell.textLabel.font = [UIFont flatFontOfSize:14];
                    cell.textLabel.text = [twitter createMessage];
                    self.messageLabel = cell.textLabel;
                    break;
            }
            break;
        case 3:
            tweetButton = (FUIButton*)[cell viewWithTag:2];
            [SZFlatUI makeNormalButton:tweetButton WithTitle:NSLocalizedString(@"Send Test & Save Data", nil)];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    InsetCell *cell = (InsetCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
        {
            for (int i = 0; i < self.twitterUsers.count; i++) {
                if (i == indexPath.row) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    twitter.username = [self.twitterUsers objectAtIndex:i];
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            break;
        }
        case 1:
        {
            if ([[cell viewWithTag:2] isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)[cell viewWithTag:2];
                [textField becomeFirstResponder];
            } else {
                UITextView *textView = (UITextView *)[cell viewWithTag:2];
                [textView becomeFirstResponder];
            }
            break;
        }
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                    [self showComposeBarView];
                    break;
                    
                default:
                    break;
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    NSArray *titleArray = [NSArray arrayWithObjects:NSLocalizedString(@"Please select account", nil),
                                                    NSLocalizedString(@"Please write recipient username", nil),
                                                    NSLocalizedString(@"Message", nil),
                                                    @" ", nil];
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *)view;
        tableViewHeaderFooterView.textLabel.text = [titleArray objectAtIndex:section];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    twitter.toAddress = textField.text;
    [textField resignFirstResponder];
    return YES;
}

- (void)showComposeBarView
{
    [self registerForKeyboardNotifications];
    
//    CGRect viewBounds = [[self view] bounds];
    CGRect viewBounds = self.view.frame;
    CGRect frame = CGRectMake(0.0f,
                              viewBounds.size.height-PHFComposeBarViewInitialHeight-self.navigationController.navigationBar.frame.size.height,
                              viewBounds.size.width,
                              PHFComposeBarViewInitialHeight);
    // PHFComposeBarViewインスタンスの作成
    myComposeBarView = [[PHFComposeBarView alloc] initWithFrame:frame];
    // 最大文字数を設定
    [myComposeBarView setMaxCharCount:140];
    // 最大行数を設定
    [myComposeBarView setMaxLinesCount:5];
    // プレースホルダー内容を設定
    [myComposeBarView setPlaceholder:@"Type message..."];
    // ユーティリティボタンの画像を設定
//    [myComposeBarView setUtilityButtonImage:[UIImage imageNamed:@"Camera"]];
    [myComposeBarView setUtilityButtonImage:[UIImage imageNamed:@"Close-48@2x"]];
    // デリゲートを指定
    [myComposeBarView setDelegate:self];
    
//    [myComposeBarView.utilityButton removeFromSuperview];
    [myComposeBarView setButtonTitle:@"Done"];
    [myComposeBarView becomeFirstResponder];
    
    [self.view addSubview:myComposeBarView];
}

// メインボタンを押下時のイベントメソッド
- (void)composeBarViewDidPressButton:(PHFComposeBarView *)composeBarView
{
    [SZTwitter setMessage:[composeBarView text]];
    [composeBarView resignFirstResponder];
    [self removeAllKeyboardNotifications];
    [composeBarView removeFromSuperview];
    [self.tableView reloadData];
}

// ユーティリティボタンを押下時のイベントメソッド
- (void)composeBarViewDidPressUtilityButton:(PHFComposeBarView *)composeBarView
{
    [composeBarView resignFirstResponder];
    [self removeAllKeyboardNotifications];
    [composeBarView removeFromSuperview];
}

// ビューフレーム変更しようとする時の通知メソッド
// NotificationCenterから「PHFComposeBarViewWillChangeFrameNotification」通知を受け取ってもよい
- (void)composeBarView:(PHFComposeBarView *)composeBarView
   willChangeFromFrame:(CGRect)startFrame
               toFrame:(CGRect)endFrame
              duration:(NSTimeInterval)duration
        animationCurve:(UIViewAnimationCurve)animationCurve
{
    
}

// ビューフレーム変更時の通知メソッド
// NotificationCenterから「PHFComposeBarViewDidChangeFrameNotification」通知を受け取ってもよい
- (void)composeBarView:(PHFComposeBarView *)composeBarView
    didChangeFromFrame:(CGRect)startFrame
               toFrame:(CGRect)endFrame
{
    
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeAllKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    NSDictionary *info  = aNotification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    CGRect viewBounds = [[self view] bounds];
    [UIView beginAnimations: @"TransitionAnimation" context:nil];
    [UIView setAnimationDuration:0.3f];
    myComposeBarView.frame = CGRectMake(0.0f,
                                        viewBounds.size.height-PHFComposeBarViewInitialHeight-keyboardFrame.size.height-self.navigationController.navigationBar.frame.size.height,
                                        viewBounds.size.width,
                                        PHFComposeBarViewInitialHeight);
    [UIView commitAnimations];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [myComposeBarView resignFirstResponder];
    [self removeAllKeyboardNotifications];
    [myComposeBarView removeFromSuperview];
}

@end
