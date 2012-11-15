//
//  WXApi_Addition.h
//  WeiXinDemo
//
//  Created by 滕 松 on 12-11-15.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

#pragma mark - Request
typedef enum {
    SWXRequestBase,
    SWXRequestSendMessageToWX,
    SWXRequestSendAuth,
    SWXRequestGetMessageFromWX,
    SWXRequestShowMessageFromWX,
}SWXRequestType;

@interface BaseReq (Addition)
- (SWXRequestType)stype;
@end
@interface SendMessageToWXReq (Addition)

@end
@interface SendAuthReq (Addition)

@end
@interface GetMessageFromWXReq (Addition)

@end
@interface ShowMessageFromWXReq (Addition)

@end

#pragma mark - Response
typedef enum {
    SWXResponseBase,
    SWXResponseSendMessageToWX,
    SWXResponseSendAuth,
    SWXResponseGetMessageFromWX,
    SWXResponseShowMessageFromWX,
}SWXResponseType;

@interface BaseResp (Addition)
- (int)serrorCode;
- (SWXResponseType)stype;
@end
@interface SendMessageToWXResp (Addition)

@end
@interface SendAuthResp (Addition)

@end
@interface GetMessageFromWXResp (Addition)

@end
@interface ShowMessageFromWXResp (Addition)

@end

#pragma mark - WXApi
@interface WXApi (Addition)
+ (BOOL)registerWXApp;
+ (BOOL)handleWXOpenURL:(NSURL *)url;
@end
