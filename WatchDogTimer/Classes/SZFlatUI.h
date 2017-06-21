//
//  SZFlatUI.h
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlatUIKit.h"

@interface SZFlatUI : NSObject

+ (void)makeNormalButton:(FUIButton*)fButton WithTitle:(NSString*)title;
+ (void)makeCancelButton:(FUIButton*)fButton WithTitle:(NSString*)title;
+ (FUISwitch *)makeSwitch;
+ (void)makeNavigationBar:(UINavigationBar*)navigationBar;
+ (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message;
+ (void)makeAlertView:(FUIAlertView*)alertView;
+ (UILabel*)makeLabelWithFrame:(CGRect)rect text:(NSString*)text size:(CGFloat)size;

@end
