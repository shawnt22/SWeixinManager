//
//  AppDelegate.m
//  WeiXinDemo
//
//  Created by 滕 松 on 12-11-14.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
- (void)alertWithTitle:(NSString *)title Message:(NSString *)message;
@end

@implementation AppDelegate

- (void)alertWithTitle:(NSString *)title Message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"register weixin : %d", [WXApi registerWXApp]);
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIButton *_weixin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _weixin.frame = CGRectMake(20, ceilf((self.window.bounds.size.height-44)/2), 120, 44);
    [_weixin addTarget:self action:@selector(shareToWeixinAction:) forControlEvents:UIControlEventTouchUpInside];
    [_weixin setTitle:@"分享到微信" forState:UIControlStateNormal];
    [self.window addSubview:_weixin];
    
    UIButton *_pengyouquan = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _pengyouquan.frame = CGRectMake(_weixin.frame.origin.x+_weixin.frame.size.width+40, _weixin.frame.origin.y, 120, 44);
    [_pengyouquan addTarget:self action:@selector(shareToPengyouquanAction:) forControlEvents:UIControlEventTouchUpInside];
    [_pengyouquan setTitle:@"分享到朋友圈" forState:UIControlStateNormal];
    [self.window addSubview:_pengyouquan];
    
    UIButton *_login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _login.frame = CGRectMake(_weixin.frame.origin.x, _weixin.frame.origin.y+_weixin.frame.size.height+40, 120, 44);
    [_login addTarget:self action:@selector(loginWithWeixinAction:) forControlEvents:UIControlEventTouchUpInside];
    [_login setTitle:@"通过微信登陆" forState:UIControlStateNormal];
    [self.window addSubview:_login];
    
    return YES;
}

- (void)loginWithWeixinAction:(id)sender {
    [[SWeiXinManager shareWeiXinManager] addObserver:self];
    [[SWeiXinManager shareWeiXinManager] author];
}
- (void)shareToWeixinAction:(id)sender {
    [[SWeiXinManager shareWeiXinManager] addObserver:self];
    [[SWeiXinManager shareWeiXinManager] shareVideoToWeixinWithURLPath:test_video_url_sina Title:@"分享到微信 视频的标题 title" Description:@"分享到微信 内容 description"];
}
- (void)shareToPengyouquanAction:(id)sender {
    [[SWeiXinManager shareWeiXinManager] addObserver:self];
    [[SWeiXinManager shareWeiXinManager] shareVideoToPengyouquanWithURLPath:test_video_url_sina Title:@"分享到朋友圈 视频的标题 title" Description:@"分享到朋友圈 内容 description"];
}

#pragma mark weixin delegate
- (void)weixinManager:(SWeiXinManager *)manager successResponse:(SWXResponseType)type UserInfo:(id)info {
    [self alertWithTitle:@"成功" Message:[NSString stringWithFormat:@"response 类型 : %d", type]];
}
- (void)weixinManager:(SWeiXinManager *)manager failResponse:(SWXResponseType)type Error:(NSError *)error {
    [self alertWithTitle:@"失败" Message:[NSString stringWithFormat:@"response 类型 : %d\nError : %@", type, error]];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleWXOpenURL:url];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleWXOpenURL:url];
}



#pragma mark app delegate
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

