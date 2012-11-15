//
//  SWeiXinManager.m
//  WeiXinDemo
//
//  Created by 滕 松 on 12-11-14.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SWeiXinManager.h"

#pragma mark - Base
static SWeiXinManager *wxManager = nil;

@interface SWeiXinManager ()
@property (nonatomic, retain) NSMutableSet *observers;
+ (BOOL)hasErrorWithWXResponse:(BaseResp *)response;
- (NSError *)errorWithWXResponse:(BaseResp *)response;
- (NSError *)errorWithWeiXinManagerErrorCode:(WeiXinManagerErrorCode)code;
@end

@implementation SWeiXinManager
@synthesize observers;

#pragma mark init & dealloc
+ (SWeiXinManager *)shareWeiXinManager {
    if (wxManager == nil) {
        wxManager = [[SWeiXinManager alloc] init];
    }
    return wxManager;
}
- (id)init {
    self = [super init];
    if (self) {
        self.observers = [NSMutableSet set];
    }
    return self;
}
- (void)dealloc {
    self.observers = nil;
    [super dealloc];
}

#pragma mark wx delegate
-(void) onReq:(BaseReq*)req {
    
}
-(void) onResp:(BaseResp*)resp {
    if ([SWeiXinManager hasErrorWithWXResponse:resp]) {
        [self notifyWeixinManager:self failResponse:[resp stype] Error:[self errorWithWXResponse:resp]];
    } else {
        [self notifyWeixinManager:self successResponse:[resp stype]];
    }
}

#pragma mark error
+ (BOOL)hasErrorWithWXResponse:(BaseResp *)response {
    return response.errCode == 0 ? NO : YES;
}
- (NSError *)errorWithWXResponse:(BaseResp *)response {
    return [self errorWithWeiXinManagerErrorCode:[response serrorCode]];
}
- (NSError *)errorWithWeiXinManagerErrorCode:(WeiXinManagerErrorCode)code {
    NSString *description = @"";
    switch (code) {
        default:
            description = @"分享到微信失败了";
            break;
    }
    return [NSError errorWithDomain:@"SWXManagerDomain" code:code userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, NSLocalizedDescriptionKey, nil]];
}

@end

#pragma mark - Share
@implementation SWeiXinManager (Share)

- (void)shareVideoToWeixinWithURLPath:(NSString *)urlPath Title:(NSString *)title Description:(NSString *)description {
    [self shareVideo:urlPath Title:title Description:description toWXScene:WXSceneSession];
}
- (void)shareVideoToPengyouquanWithURLPath:(NSString *)urlPath Title:(NSString *)title Description:(NSString *)description {
    [self shareVideo:urlPath Title:title Description:description toWXScene:WXSceneTimeline];
}
- (void)shareVideo:(NSString *)videoURLPath Title:(NSString *)title Description:(NSString *)description toWXScene:(int)scene {
    WXMediaMessage *_message = [WXMediaMessage message];
    if (![SWeiXinManager isEmptyString:title]) {
        _message.title = title;
    }
    if (![SWeiXinManager isEmptyString:description]) {
        _message.description = description;
    }
    WXVideoObject *_video = [WXVideoObject object];
    _video.videoUrl = videoURLPath;
    _message.mediaObject = _video;
    
    SendMessageToWXReq *_request = [[SendMessageToWXReq alloc] init];
    _request.bText = NO;
    _request.scene = scene;
    _request.message = _message;
    
    [WXApi sendReq:_request];
    [_request release];
}

@end

#pragma mark - Observer
@implementation SWeiXinManager (Observer)

- (void)addObserver:(id<SWeiXinManagerDelegate>)observer {
    [self.observers addObject:observer];
}
- (void)removeObserver:(id<SWeiXinManagerDelegate>)observer {
    [self.observers removeObject:observer];
}
- (void)removeAllObservers {
    [self.observers removeAllObjects];
}

@end

#pragma mark - Notify
@implementation SWeiXinManager (Notify)

- (void)notifyWeixinManager:(SWeiXinManager *)manager successResponse:(SWXResponseType)type {
    for (NSInteger index = 0; index < [[self.observers allObjects] count]; index++) {
        id<SWeiXinManagerDelegate> observer = [[self.observers allObjects] objectAtIndex:index];
        if ([observer respondsToSelector:@selector(weixinManager:successResponse:)]) {
            [observer weixinManager:manager successResponse:type];
            [self removeObserver:observer];
            index--;
        }
    }
}
- (void)notifyWeixinManager:(SWeiXinManager *)manager failResponse:(SWXResponseType)type Error:(NSError *)error {
    for (NSInteger index = 0; index < [[self.observers allObjects] count]; index++) {
        id<SWeiXinManagerDelegate> observer = [[self.observers allObjects] objectAtIndex:index];
        if ([observer respondsToSelector:@selector(weixinManager:failResponse:Error:)]) {
            [observer weixinManager:manager failResponse:type Error:error];
            [self removeObserver:observer];
            index--;
        }
    }
}

@end

#pragma mark - Util
@implementation SWeiXinManager (Util)

+ (NSString *)getWeixinAppID {
    NSString *result = nil;
    NSArray *_urlSchemes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    for (id _scheme in _urlSchemes) {
        if ([[_scheme objectForKey:@"CFBundleURLName"] isEqualToString:@"WeiXin"]) {
            result = [[_scheme objectForKey:@"CFBundleURLSchemes"] lastObject];
        }
    }
    return result;
}
+ (BOOL)isEmptyString:(NSString *)string {
    return string == nil || [string length] == 0 ? YES : NO;
}

@end