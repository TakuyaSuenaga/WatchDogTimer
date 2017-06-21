//
//  SZFlatUI.m
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import "SZFlatUI.h"

@interface SZFlatUI ()

@end

@implementation SZFlatUI

+ (void)makeNormalButton:(FUIButton*)fButton WithTitle:(NSString*)title
{
    [fButton setTitle:title forState:UIControlStateNormal];
    fButton.buttonColor = [UIColor turquoiseColor];
    fButton.shadowColor = [UIColor greenSeaColor];
    fButton.shadowHeight = 3.0f;
    fButton.cornerRadius = 6.0f;
    fButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [fButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [fButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

+ (void)makeCancelButton:(FUIButton*)fButton WithTitle:(NSString*)title
{
    [fButton setTitle:title forState:UIControlStateNormal];
    fButton.buttonColor = [UIColor alizarinColor];
    fButton.shadowColor = [UIColor pomegranateColor];
    fButton.shadowHeight = 3.0f;
    fButton.cornerRadius = 6.0f;
    fButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [fButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [fButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

+ (FUISwitch *)makeSwitch
{
    FUISwitch *fSwitch = [[FUISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    fSwitch.onColor = [UIColor turquoiseColor];
    fSwitch.offColor = [UIColor cloudsColor];
    fSwitch.onBackgroundColor = [UIColor midnightBlueColor];
    fSwitch.offBackgroundColor = [UIColor silverColor];
    fSwitch.offLabel.font = [UIFont boldFlatFontOfSize:14];
    fSwitch.onLabel.font = [UIFont boldFlatFontOfSize:14];
    return fSwitch;
}

+ (void)makeNavigationBar:(UINavigationBar*)navigationBar
{
    [navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
}

+ (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil, nil];
    [self makeAlertView:alertView];
    [alertView show];
}

+ (void)makeAlertView:(FUIAlertView*)alertView
{
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
}

+ (UILabel*)makeLabelWithFrame:(CGRect)rect text:(NSString*)text size:(CGFloat)size
{
    UILabel *fLabel = [[UILabel alloc] initWithFrame:rect];
    fLabel.font = [UIFont flatFontOfSize:size];
    fLabel.text = text;
    return fLabel;
}


@end
