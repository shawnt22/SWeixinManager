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
@property (nonatomic, retain) NSMutableSet *responseObservers;
@property (nonatomic, retain) NSMutableSet *requestObservers;
+ (BOOL)hasErrorWithWXResponse:(BaseResp *)response;
+ (NSError *)errorWithWXResponse:(BaseResp *)response;
+ (NSError *)errorWithWeiXinManagerErrorCode:(WeiXinManagerErrorCode)code;
@end

@implementation SWeiXinManager
@synthesize responseObservers, requestObservers;

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
        self.responseObservers = [NSMutableSet set];
        self.requestObservers = [NSMutableSet set];
    }
    return self;
}
- (void)dealloc {
    self.responseObservers = nil;
    self.requestObservers = nil;
    [super dealloc];
}

#pragma mark wx delegate
-(void) onReq:(BaseReq*)req {
    [self notifyWeixinManager:self onRequestFromWX:[req stype] UserInfo:req];
}
-(void) onResp:(BaseResp*)resp {
    if ([SWeiXinManager hasErrorWithWXResponse:resp]) {
        [self notifyWeixinManager:self failResponse:[resp stype] Error:[SWeiXinManager errorWithWXResponse:resp]];
    } else {
        [self notifyWeixinManager:self successResponse:[resp stype] UserInfo:resp];
    }
}

#pragma mark error
+ (BOOL)hasErrorWithWXResponse:(BaseResp *)response {
    return response.errCode == WeiXinManagerSuccess ? NO : YES;
}
+ (NSError *)errorWithWXResponse:(BaseResp *)response {
    return [SWeiXinManager errorWithWeiXinManagerErrorCode:response.errCode];
}
+ (NSError *)errorWithWeiXinManagerErrorCode:(WeiXinManagerErrorCode)code {
    NSString *description = @"";
    switch (code) {
        case WeiXinManagerErrorRegister:
            description = @"无法连接到微信";
            break;
        case WeiXinManagerErrorUserCancel:
            description = @"取消了微信相关的操作";
            break;
        case WeiXinManagerErrorSendFail:
            description = @"分享到微信失败了";
            break;
        case WeiXinManagerErrorAuthDeny:
            description = @"微信认证失败了";
            break;
        case WeiXinManagerErrorUnsupport:
            description = @"微信不支持";
            break;
        default:
            description = @"分享到微信失败了";
            break;
    }
    return [NSError errorWithDomain:@"SWXManagerDomain" code:code userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, NSLocalizedDescriptionKey, nil]];
}

@end

#pragma mark - Others
@implementation SWeiXinManager (Others)

- (void)author {
    SendAuthReq *_request = [[SendAuthReq alloc] init];
    _request.scope = @"post_timeline";
    _request.state = @"xxx";
    
    [WXApi sendReq:_request];
    [_request release];
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
typedef enum {
    WXManagerObserverRequest,
    WXManagerObserverResponse,
}WXManagerObserverType;

@interface SWeiXinManager (Observer_Privated)
- (void)addObserver:(id)observer Type:(WXManagerObserverType)type;
- (void)removeObserver:(id)observer Type:(WXManagerObserverType)type;
- (void)removeAllObserversWithType:(WXManagerObserverType)type;
- (NSMutableSet *)observersWithType:(WXManagerObserverType)type;
@end

@implementation SWeiXinManager (Observer_Privated)
- (NSMutableSet *)observersWithType:(WXManagerObserverType)type {
    return type == WXManagerObserverRequest ? self.requestObservers : self.responseObservers;
}
- (void)addObserver:(id)observer Type:(WXManagerObserverType)type {
    [[self observersWithType:type] addObject:observer];
}
- (void)removeObserver:(id)observer Type:(WXManagerObserverType)type {
    [[self observersWithType:type] removeObject:observer];
}
- (void)removeAllObserversWithType:(WXManagerObserverType)type {
    [[self observersWithType:type] removeAllObjects];
}
@end

@implementation SWeiXinManager (Observer)

- (void)addResponseObserver:(id<SWXManagerResponseDelegate>)observer {
    [self addObserver:observer Type:WXManagerObserverResponse];
}
- (void)removeResponseObserver:(id<SWXManagerResponseDelegate>)observer {
    [self removeObserver:observer Type:WXManagerObserverResponse];
}
- (void)removeAllResponseObservers {
    [self removeAllObserversWithType:WXManagerObserverResponse];
}

- (void)addRequestObserver:(id<SWXManagerRequestDelegate>)observer {
    [self addObserver:observer Type:WXManagerObserverRequest];
}
- (void)removeRequestObserver:(id<SWXManagerRequestDelegate>)observer {
    [self removeObserver:observer Type:WXManagerObserverRequest];
}
- (void)removeAllRequestObservers {
    [self removeAllObserversWithType:WXManagerObserverRequest];
}

@end

#pragma mark - Notify
@implementation SWeiXinManager (Notify)

- (void)notifyWeixinManager:(SWeiXinManager *)manager successResponse:(SWXResponseType)type UserInfo:(id)info {
    for (NSInteger index = 0; index < [[self.responseObservers allObjects] count]; index++) {
        id<SWXManagerResponseDelegate> observer = [[self.responseObservers allObjects] objectAtIndex:index];
        if ([observer respondsToSelector:@selector(weixinManager:successResponse:UserInfo:)]) {
            [observer weixinManager:manager successResponse:type UserInfo:info];
            [self removeResponseObserver:observer];
            index--;
        }
    }
}
- (void)notifyWeixinManager:(SWeiXinManager *)manager failResponse:(SWXResponseType)type Error:(NSError *)error {
    for (NSInteger index = 0; index < [[self.responseObservers allObjects] count]; index++) {
        id<SWXManagerResponseDelegate> observer = [[self.responseObservers allObjects] objectAtIndex:index];
        if ([observer respondsToSelector:@selector(weixinManager:failResponse:Error:)]) {
            [observer weixinManager:manager failResponse:type Error:error];
            [self removeResponseObserver:observer];
            index--;
        }
    }
}
- (void)notifyWeixinManager:(SWeiXinManager *)manager onRequestFromWX:(SWXRequestType)type UserInfo:(id)info {
    for (NSInteger index = 0; index < [[self.requestObservers allObjects] count]; index++) {
        id<SWXManagerRequestDelegate> observer = [[self.requestObservers allObjects] objectAtIndex:index];
        if ([observer respondsToSelector:@selector(weixinManager:onRequestFromWX:UserInfo:)]) {
            [observer weixinManager:manager onRequestFromWX:type UserInfo:info];
            [self removeRequestObserver:observer];
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
    return string == nil || ![string isKindOfClass:[NSString class]] || [string length] == 0 ? YES : NO;
}

@end