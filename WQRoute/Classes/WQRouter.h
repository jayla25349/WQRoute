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

//注册服务
- (void)registerPattern:(NSString *)pattern target:(id)target selector:(SEL)selector;

//注册中间件
- (void)registerMiddleware:(id<WQRouteMiddlewareProtocol>)middleware;
- (void)unRegisterMiddleware:(id<WQRouteMiddlewareProtocol>)middleware;

//路由
- (BOOL)routeRequest:(WQRouteRequest *)request;
- (BOOL)routeURL:(NSURL *)URL data:(nullable id)data callBack:(nullable WQRouteCallbackBlock)block;
- (BOOL)routeURLString:(NSString *)URLString data:(nullable id)data callBack:(nullable WQRouteCallbackBlock)block;

@end

NS_ASSUME_NONNULL_END


#define ROUTE(pattern, method) \
[[WQRouter defaultRouter] registerPattern:pattern target:self selector:@selector(method)];

#ifdef DEBUG
#define ROUTELog(format, ...)   NSLog(format, ##__VA_ARGS__)
#else
#define ROUTELog(format, ...)
#endif
