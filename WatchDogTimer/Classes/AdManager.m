//
//  AdManager.m
//  Maru
//
//  Created by 末永 琢也 on 2014/02/04.
//  Copyright (c) 2014年 末永 琢也. All rights reserved.
//

#import "AdManager.h"


static AdManager *s_adManager;
static ADBannerView *s_adBannerView;

@interface AdManager () <ADBannerViewDelegate>

@end

@implementation AdManager

+ (ADBannerView*)shardAdBannerView
{
    if (s_adBannerView == nil) {
        s_adManager = [[AdManager alloc] init];
        s_adBannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        s_adBannerView.autoresizesSubviews = YES;
        s_adBannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        CGSize s = [UIScreen mainScreen].bounds.size;
        s_adBannerView.frame = CGRectMake(0, 0, s.width, 50);
        s_adBannerView.delegate = s_adManager;
        s_adBannerView.alpha = 0.f;
    }
    return s_adBannerView;
}

+ (void)removeAd
{
    [s_adBannerView removeFromSuperview];
    s_adBannerView.delegate = nil;
    s_adBannerView = nil;
    s_adManager = nil;
}

#pragma mark - AdBannerDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView animateWithDuration:0.3f animations:^{
        banner.alpha = 1.f;
    }];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"[ERROR] %@", NSStringFromiAdError(error));
    [UIView animateWithDuration:0.3f animations:^{
        banner.alpha = 0.f;
    }];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner;
{

}

NSString *NSStringFromiAdError(NSError *error)
{
    switch (error.code) {
        case 0:
            return @"ADErrorUnknown 不明または予期しないエラー";
        case 1:
            return @"ADErrorServerFailure 広告サーバーへの接続失敗";
        case 2:
            return @"ADErrorLoadingThrottled 現在広告サーバーからのダウンロードが抑制されている";
        case 3:
            return @"ADErrorInventoryUnavailable 現在ダウンロード出来る広告がない";
        case 4:
            return @"ADErrorConfigurationError アプリケーションが広告を通知するように設定していない";
        case 5:
            return @"ADErrorBannerVisibleWithoutContent バナーは表示されているが、バナー広告画像は表示されていない";
        case 6:
            return @"ADErrorApplicationInactive アプリケーションがアクティブでないため、広告コンテンツが利用出来ない";
        default:
            return [NSString stringWithFormat:@"Unknown ADError.code[%ld]", (long)error.code];
    }
}

@end
