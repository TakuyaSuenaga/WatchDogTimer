//
//  SZTwitter.h
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/06/02.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTwitter : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *toAddress;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;


- (void)getTwitterAccountOnCompletion:(void (^)(NSMutableArray *))completionHandler;
- (void)postDirectMessageOnTwitter:(void (^)(BOOL, NSString *))completionHandler;
- (NSString*)createMessage;
- (void)saveProperty;
- (id)initWithProperty;
+ (id)allocWithProperty;
+ (void)setTwitterOn:(BOOL)on;
+ (BOOL)getTwitterOn;
+ (void)setLocationOn:(BOOL)on;
+ (BOOL)getLocationOn;
+ (void)setMessage:(NSString*)message;
+ (NSString*)getMessage;

@end
