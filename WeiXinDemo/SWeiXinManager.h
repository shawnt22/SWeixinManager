//
//  SWeiXinManager.h
//  WeiXinDemo
//
//  Created by 滕 松 on 12-11-14.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApi_Addition.h"

#define test_video_url_sina     @"http://video.sina.com.cn/v/b/90027333-2214257545.html"
#define test_video_url_56       @"http://www.56.com/w55/play_album-aid-9935737_vid-Njk1NjQyMTc.html"
#define test_video_url_ifeng    @"http://v.ifeng.com/vblog/dv/201211/b2c37bdc-d1d0-4511-81ba-61082f3111af.shtml"
#define test_video_url_youku    @"http://v.youku.com/v_show/id_XNDc0OTgyMTY4.html"

typedef enum {
    WeiXinManagerErrorDefault,
}WeiXinManagerErrorCode;


#pragma mark - Base
@class SWeiXinManager;
@protocol SWeiXinManagerDelegate <NSObject>
@optional
- (void)weixinManager:(SWeiXinManager *)manager successResponse:(SWXResponseType)type;
- (void)weixinManager:(SWeiXinManager *)manager failResponse:(SWXResponseType)type Error:(NSError *)error;
@end

@interface SWeiXinManager : NSObject <WXApiDelegate>
+ (SWeiXinManager *)shareWeiXinManager;
@end

#pragma mark - Share
@interface SWeiXinManager (Share)
- (void)shareVideoToWeixinWithURLPath:(NSString *)urlPath Title:(NSString *)title Description:(NSString *)description;
- (void)shareVideoToPengyouquanWithURLPath:(NSString *)urlPath Title:(NSString *)title Description:(NSString *)description;
- (void)shareVideo:(NSString *)videoURLPath Title:(NSString *)title Description:(NSString *)description toWXScene:(int)scene;
@end

#pragma mark - Observer
@interface SWeiXinManager (Observer)
- (void)addObserver:(id<SWeiXinManagerDelegate>)observer;
- (void)removeObserver:(id<SWeiXinManagerDelegate>)observer;
- (void)removeAllObservers;
@end

#pragma mark - Notify
@interface SWeiXinManager (Notify)
- (void)notifyWeixinManager:(SWeiXinManager *)manager successResponse:(SWXResponseType)type;
- (void)notifyWeixinManager:(SWeiXinManager *)manager failResponse:(SWXResponseType)type Error:(NSError *)error;
@end

#pragma mark - Util
@interface SWeiXinManager (Util)
+ (NSString *)getWeixinAppID;
+ (BOOL)isEmptyString:(NSString *)string;
@end
