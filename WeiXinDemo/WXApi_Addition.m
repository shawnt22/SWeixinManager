//
//  WXApi_Addition.m
//  WeiXinDemo
//
//  Created by 滕 松 on 12-11-15.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "WXApi_Addition.h"

#pragma mar - Request
@implementation BaseReq (Addition)
- (SWXRequestType)stype {
    return SWXRequestBase;
}
@end
@implementation SendMessageToWXReq (Addition)
- (SWXRequestType)stype {
    return SWXRequestSendMessageToWX;
}
@end
@implementation SendAuthReq (Addition)
- (SWXRequestType)stype {
    return SWXRequestSendAuth;
}
@end
@implementation GetMessageFromWXReq (Addition)
- (SWXRequestType)stype {
    return SWXRequestGetMessageFromWX;
}
@end
@implementation ShowMessageFromWXReq (Addition)
- (SWXRequestType)stype {
    return SWXRequestShowMessageFromWX;
}
@end

#pragma mark - Response
@implementation BaseResp (Addition)
- (SWXResponseType)stype {
    return SWXResponseBase;
}
@end
@implementation SendMessageToWXResp (Addition)
- (SWXResponseType)stype {
    return SWXResponseSendMessageToWX;
}
@end
@implementation SendAuthResp (Addition)
- (SWXResponseType)stype {
    return SWXResponseSendAuth;
}
@end
@implementation GetMessageFromWXResp (Addition)
- (SWXResponseType)stype {
    return SWXResponseGetMessageFromWX;
}
@end
@implementation ShowMessageFromWXResp (Addition)
- (SWXResponseType)stype {
    return SWXResponseShowMessageFromWX;
}
@end

#pragma mark - WXApi
#import "SWeiXinManager.h"
@implementation WXApi (Addition)
+ (BOOL)registerWXApp {
    return [WXApi registerApp:[SWeiXinManager getWeixinAppID]];
}
+ (BOOL)handleWXOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[SWeiXinManager shareWeiXinManager]];
}
@end