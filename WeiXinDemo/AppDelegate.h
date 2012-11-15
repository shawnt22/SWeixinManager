//
//  AppDelegate.h
//  WeiXinDemo
//
//  Created by 滕 松 on 12-11-14.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWeiXinManager.h"

#define test_video_url_sina     @"http://video.sina.com.cn/v/b/90027333-2214257545.html"
#define test_video_url_56       @"http://www.56.com/w55/play_album-aid-9935737_vid-Njk1NjQyMTc.html"
#define test_video_url_ifeng    @"http://v.ifeng.com/vblog/dv/201211/b2c37bdc-d1d0-4511-81ba-61082f3111af.shtml"
#define test_video_url_youku    @"http://v.youku.com/v_show/id_XNDc0OTgyMTY4.html"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SWeiXinManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
