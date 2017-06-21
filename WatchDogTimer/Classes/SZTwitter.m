//
//  SZTwitter.m
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

@import Accounts;
@import Twitter;
@import Social;

#import "SZTwitter.h"
#import "DLog.h"

@implementation SZTwitter

#pragma mark - Twitter

- (void)getTwitterAccountOnCompletion:(void (^)(NSMutableArray *))completionHandler
{
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [store requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(granted) {
                // Remember that twitterType was instantiated above
                NSArray *twitterAccounts = [store accountsWithAccountType:twitterType];
                
                // If there are no accounts, we need to pop up an alert
                if(twitterAccounts == nil || [twitterAccounts count] == 0) {
                    completionHandler(nil);
                } else {
                    NSMutableArray *users = [[NSMutableArray alloc] init];
                    for (ACAccount *twitterAccount in twitterAccounts) {
                        [users addObject:twitterAccount.username];
                    }
                    completionHandler(users);
                }
            }
        });
    }];
}

- (void)postDirectMessageOnTwitter:(void (^)(BOOL, NSString *))completionHandler
{
    DLog();
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] == NO) {
        completionHandler(NO, NSLocalizedString(@"Service is not available for Twitter", nil));
        return;
    }
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *accountArray = [accountStore accountsWithAccountType:accountType];
    ACAccount *account = nil;
    for (ACAccount *search in accountArray) {
        if ([search.username isEqualToString:self.username]) {
            account = search;
            break;
        }
    }
    if (account == nil) {
        completionHandler(NO, NSLocalizedString(@"No user selected", nil));
        return;
    }
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/direct_messages/new.json"];
                NSDictionary *parameters = @{@"text": [self createMessage],
                                             @"screen_name": self.toAddress};
                
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                        requestMethod:SLRequestMethodPOST
                                                                  URL:url
                                                           parameters:parameters];
                
                request.account = account;
                [request performRequestWithHandler:^(NSData *responseData,
                                                     NSHTTPURLResponse *urlResponse,
                                                     NSError *error)
                 {
                     NSString *message = [NSString stringWithFormat:@"The response status code is %ld", (long)urlResponse.statusCode];
                     if (responseData) {
                         DLog(@"responseData=%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             completionHandler(YES, @"Post Success!");
                         }
                         else {
                             DLog(@"%@", message);
                             NSString *error = [NSString stringWithFormat:@"Post Failed!\n%@", message];
                             completionHandler(NO, error);
                         }
                     }
                     else {
                         DLog(@"%@", message);
                         NSString *error = [NSString stringWithFormat:@"Post Failed!\n%@", message];
                         completionHandler(NO, error);
                     }
                 }];
            }
            else {
                NSString *message = NSLocalizedString(@"Login failed", nil);
                DLog(@"%@", message);
                NSString *error = [NSString stringWithFormat:@"Post Failed!\n%@", message];
                completionHandler(NO, error);
            }
        });
    }];
}

- (NSString*)createMessage
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    NSString *location = @"";
    if ([SZTwitter getLocationOn] == YES) {
        location = NSLocalizedString(@"Current Location:\n", nil);
        NSString *formatter = NSLocalizedString(@"http://maps.google.co.jp/maps?q=%f,%f&hl=en", nil);;
        location = [location stringByAppendingString:[NSString stringWithFormat:formatter, self.latitude, self.longitude]];
    }
    NSString *body = [SZTwitter getMessage];
    if (body == NULL) {
        NSString *formatter = NSLocalizedString(@"Message from %@", nil);
        body = [NSString stringWithFormat:formatter, [[UIDevice currentDevice] name]];
    }
    NSString *message = [NSString stringWithFormat:@"[%@]\n%@\n%@", dateString, location, body];
    if (message.length > 140) {
        message = [message substringToIndex:140];
    }
    return message;
}

- (void)saveProperty
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.username forKey:@"SZSocial_username"];
    [ud setObject:self.toAddress forKey:@"SZSocial_toAddress"];
}

- (id)initWithProperty
{
    if (self = [super init]) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        self.username = [ud stringForKey:@"SZSocial_username"];
        self.toAddress = [ud stringForKey:@"SZSocial_toAddress"];
    }
    return self;
}

+ (id)allocWithProperty
{
    return [[SZTwitter alloc] initWithProperty];
}

+ (void)setTwitterOn:(BOOL)on
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:on forKey:@"SZSocial_twitterOn"];
}

+ (BOOL)getTwitterOn
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@"SZSocial_twitterOn"];
}

+ (void)setLocationOn:(BOOL)on
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:on forKey:@"SZSocial_LocationOn"];
}

+ (BOOL)getLocationOn
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@"SZSocial_LocationOn"];
}

+ (void)setMessage:(NSString*)message
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:message forKey:@"SZSocial_Message"];
}

+ (NSString*)getMessage
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"SZSocial_Message"];
}

@end
