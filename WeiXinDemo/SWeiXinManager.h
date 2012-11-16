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

typedef enum {
    WeiXinManagerErrorCommon = WXErrCodeCommon,
    WeiXinManagerErrorUserCancel = WXErrCodeUserCancel, //  用户不做操作直接从微信返回app时触发，可忽略
    WeiXinManagerErrorSendFail = WXErrCodeSentFail,
    WeiXinManagerErrorAuthDeny = WXErrCodeAuthDeny,
    WeiXinManagerErrorUnsupport = WXErrCodeUnsupport,
    WeiXinManagerSuccess = WXSuccess,
    WeiXinManagerErrorRegister, //  注册AppID失败
}WeiXinManagerErrorCode;


#pragma mark - Base
@class SWeiXinManager;
@protocol SWXManagerResponseDelegate <NSObject>
@optional
- (void)weixinManager:(SWeiXinManager *)manager successResponse:(SWXResponseType)type UserInfo:(id)info;
- (void)weixinManager:(SWeiXinManager *)manager failResponse:(SWXResponseType)type Error:(NSError *)error;
@end

@interface SWeiXinManager : NSObject <WXApiDelegate>
+ (SWeiXinManager *)shareWeiXinManager;
@end

#pragma mark - Others
@interface SWeiXinManager (Others)
- (void)author;
@end

#pragma mark - Share
@interface SWeiXinManager (Share)
- (void)shareVideoToWeixinWithURLPath:(NSString *)urlPath Title:(NSString *)title Description:(NSString *)description;
- (void)shareVideoToPengyouquanWithURLPath:(NSString *)urlPath Title:(NSString *)title Description:(NSString *)description;
- (void)shareVideo:(NSString *)videoURLPath Title:(NSString *)title Description:(NSString *)description toWXScene:(int)scene;
@end

#pragma mark - Observer
@interface SWeiXinManager (Observer)
- (void)addResponseObserver:(id<SWXManagerResponseDelegate>)observer;
- (void)removeResponseObserver:(id<SWXManagerResponseDelegate>)observer;
- (void)removeAllResponseObservers;
@end

#pragma mark - Notify
@interface SWeiXinManager (Notify)
- (void)notifyWeixinManager:(SWeiXinManager *)manager successResponse:(SWXResponseType)type UserInfo:(id)info;
- (void)notifyWeixinManager:(SWeiXinManager *)manager failResponse:(SWXResponseType)type Error:(NSError *)error;
@end

#pragma mark - Util
@interface SWeiXinManager (Util)
+ (NSString *)getWeixinAppID;
+ (BOOL)isEmptyString:(NSString *)string;
@end
