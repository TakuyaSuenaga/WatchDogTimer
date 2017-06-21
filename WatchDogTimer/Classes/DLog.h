//
//  DLog.h
//  WatchDogTimer
//
//  Created by Takuya Suenaga on 2014/03/05.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#ifndef WatchDogTimer_DLog_h
#define WatchDogTimer_DLog_h

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#endif
