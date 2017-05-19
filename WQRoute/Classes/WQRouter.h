//
//  WQRouter.h
//  WQRoute
//
//  Created by 青秀斌 on 2017/1/20.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQRouteMiddlewareProtocol.h"
#import "WQRouteHandler.h"
#import "WQRouteRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQRouter : NSObject

//默认路由器
+ (instancetype)defaultRouter;

//注册中间件
- (void)registerMiddleware:(id<WQRouteMiddlewareProtocol>)middleware;
- (void)unRegisterMiddleware:(id<WQRouteMiddlewareProtocol>)middleware;

//注册处理器
- (void)registerHandler:(WQRouteHandler *)handler;
- (void)unRegisterHandler:(WQRouteHandler *)handler;
- (nullable WQRouteHandler *)registerPattern:(NSString *)pattern target:(id)target selector:(SEL)selector;

//路由请求
- (BOOL)routeRequest:(WQRouteRequest *)request;
- (BOOL)routeURL:(NSURL *)URL sender:(id)sender data:(nullable id)data callback:(nullable WQRouteCallbackBlock)block;
- (BOOL)routeURLString:(NSString *)URLString sender:(nullable id)sender data:(nullable id)data callback:(nullable WQRouteCallbackBlock)block;

//是否响应
- (BOOL)isResponseURL:(NSURL *)url;
- (BOOL)isResponseURLString:(NSString *)URLString;
@end

NS_ASSUME_NONNULL_END


#define ROUTE_REGISTER(pattern, method) \
[[WQRouter defaultRouter] registerPattern:pattern target:self selector:@selector(method)];

#define ROUTE_RESPONSE(url) \
[[WQRouter defaultRouter] isResponseURLString:url]

#define ROUTE_URL(url, data_) \
[[WQRouter defaultRouter] routeURLString:url sender:self data:data_ callback:nil];

#define ROUTE_URL_CALLBACK(url, data_) \
[WQRouter defaultRouter] routeURLString:url sender:self data:data_
