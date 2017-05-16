//
//  WQRouter.h
//  WQRoute
//
//  Created by 青秀斌 on 2017/1/20.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQRouteMiddlewareProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQRouter : NSObject

//默认路由器
+ (instancetype)defaultRouter;

//注册中间件
- (void)registerMiddleware:(id<WQRouteMiddlewareProtocol>)middleware;
- (void)unRegisterMiddleware:(id<WQRouteMiddlewareProtocol>)middleware;

//注册服务
- (void)registerPattern:(NSString *)pattern target:(id)target selector:(SEL)selector;

//路由
- (BOOL)routeRequest:(WQRouteRequest *)request;
- (BOOL)routeURL:(NSURL *)URL sender:(id)sender data:(nullable id)data callBack:(nullable WQRouteCallbackBlock)block;
- (BOOL)routeURLString:(NSString *)URLString sender:(nullable id)sender data:(nullable id)data callBack:(nullable WQRouteCallbackBlock)block;

@end

NS_ASSUME_NONNULL_END


#define ROUTE_REGISTER(pattern, method) \
[[WQRouter defaultRouter] registerPattern:pattern target:self selector:@selector(method)];

#define ROUTE_URL(url, aData) \
[[WQRouter defaultRouter] routeURLString:url sender:self data:aData callBack:nil];

#define ROUTE_URL_CALLBACK(url, aData) \
[WQRouter defaultRouter] routeURLString:url sender:self data:aData


#ifdef DEBUG
#define ROUTELog(format, ...)   NSLog(format, ##__VA_ARGS__)
#else
#define ROUTELog(format, ...)
#endif
