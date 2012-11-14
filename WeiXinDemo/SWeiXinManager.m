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
-(void) onReq:(BaseReq*)req {}
-(void) onResp:(BaseResp*)resp {}

@end

#pragma mark - WXApiMap
@implementation SWeiXinManager (WXApiMap)

- (BOOL)registerWXApp {
    return [WXApi registerApp:[SWeiXinManager getWeixinAppID]];
}
- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
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

@end