//
//  SWeiXinManager.h
//  WeiXinDemo
//
//  Created by 滕 松 on 12-11-14.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

#pragma mark - Base
@class SWeiXinManager;
@protocol SWeiXinManagerDelegate <NSObject>
@optional

@end

@interface SWeiXinManager : NSObject <WXApiDelegate>

+ (SWeiXinManager *)shareWeiXinManager;

@end

#pragma mark - WXApiMap
@interface SWeiXinManager (WXApiMap)
- (BOOL)registerWXApp;
- (BOOL)handleOpenURL:(NSURL *)url;
@end

#pragma mark - Observer
@interface SWeiXinManager (Observer)
- (void)addObserver:(id<SWeiXinManagerDelegate>)observer;
- (void)removeObserver:(id<SWeiXinManagerDelegate>)observer;
- (void)removeAllObservers;
@end

#pragma mark - Notify
@interface SWeiXinManager (Notify)

@end

#pragma mark - Util
@interface SWeiXinManager (Util)
+ (NSString *)getWeixinAppID;
@end
