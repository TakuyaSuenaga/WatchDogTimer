//
//  AdManager.h
//  Maru
//
//  Created by 末永 琢也 on 2014/02/04.
//  Copyright (c) 2014年 末永 琢也. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@interface AdManager : NSObject

+ (ADBannerView*)shardAdBannerView;
+ (void)removeAd;

@end
