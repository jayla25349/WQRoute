//
//  WQRouter.m
//  WQRoute
//
//  Created by 青秀斌 on 2017/1/20.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQRouter.h"
#import "WQRouteHandler.h"

#ifdef DEBUG
#define ROUTELog(format, ...)   NSLog(format, ##__VA_ARGS__)
#else
#define ROUTELog(format, ...)
#endif

NS_ASSUME_NONNULL_BEGIN

@interface WQRouter ()
@property (nonatomic, strong) NSMutableOrderedSet<id<WQRouteMiddlewareProtocol>> *middlewares;
@property (nonatomic, strong) NSMutableOrderedSet<WQRouteHandler *> *handlers;
@end

@implementation WQRouter

- (instancetype)init {
    if (self = [super init]) {
        self.middlewares = [NSMutableOrderedSet orderedSet];
        self.handlers = [NSMutableOrderedSet orderedSet];
    }
    return self;
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (NSError *)handleException:(NSException *)exception {
    if ([exception.name isEqualToString:WQRouteURLException]) {
        return [NSError errorWithDomain:WQRouteErrorDomian code:WQRouteURLError userInfo:exception.userInfo];
    }
    if ([exception.name isEqualToString:WQRouteNotFoundException]) {
        return [NSError errorWithDomain:WQRouteErrorDomian code:WQRouteNotFoundError userInfo:exception.userInfo];
    }
    if ([exception.name isEqualToString:WQRouteDispatcherException]) {
        return [NSError errorWithDomain:WQRouteErrorDomian code:WQRouteDispatcherError userInfo:exception.userInfo];
    }
    if ([exception.name isEqualToString:WQRouteMiddlewareException]) {
        return [NSError errorWithDomain:WQRouteErrorDomian code:WQRouteMiddlewareError userInfo:exception.userInfo];
    }
    return [NSError errorWithDomain:WQRouteErrorDomian code:WQRouteUnkownError userInfo:exception.userInfo];
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

//默认路由器
+ (instancetype)defaultRouter {
    static WQRouter *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[WQRouter alloc] init];
    });
    return router;
}

//注册中间件
- (void)registerMiddleware:(id<WQRouteMiddlewareProtocol>)middleware {
    if (!middleware) {
        return;
    }
    if (![self.middlewares containsObject:middleware]) {
        [self.middlewares addObject:middleware];
        ROUTELog(@"注册中间件--->:%@", middleware);
    }
}
- (void)unRegisterMiddleware:(id<WQRouteMiddlewareProtocol>)middleware {
    if (!middleware) {
        return;
    }
    if ([self.middlewares containsObject:middleware]) {
        [self.middlewares removeObject:middleware];
        ROUTELog(@"移除中间件--->:%@", middleware);
    }
}

//注册处理器
- (void)registerHandler:(WQRouteHandler *)handler {
    if (!handler) {
        return;
    }
    if (![self.handlers containsObject:handler]) {
        [self.handlers addObject:handler];
        ROUTELog(@"注册处理器--->:%@", handler);
    }
}
- (void)unRegisterHandler:(WQRouteHandler *)handler {
    if (!handler) {
        return;
    }
    if ([self.handlers containsObject:handler]) {
        [self.handlers removeObject:handler];
        ROUTELog(@"移除处理器--->:%@", handler);
    }
}
- (nullable WQRouteHandler *)registerPattern:(NSString *)pattern target:(id)target selector:(SEL)selector {
    WQRouteHandler *handler = [WQRouteHandler handlerWithPattern:pattern target:target selector:selector];
    [self registerHandler:handler];
    return handler;
}

//路由请求
- (BOOL)routeRequest:(WQRouteRequest *)request {
    
    @try {
        ROUTELog(@"");
        ROUTELog(@"");
        ROUTELog(@"xxxxxxxxxxxxxxxxxxxxxxxxx路由开始xxxxxxxxxxxxxxxxxxxxxxxxx");
        ROUTELog(@"请求--->:%@", request);
        NSString *path = request.URL.absoluteString;
        if (!path) {
            [NSException raise:WQRouteURLException format:@"URL错误"];
        }
        
        //中间件处理
        __block WQRouteRequest *tempRequest = request;
        [self.middlewares enumerateObjectsUsingBlock:^(id<WQRouteMiddlewareProtocol>  _Nonnull middleware, NSUInteger idx, BOOL * _Nonnull stop) {
            ROUTELog(@"拦截--->:%@", middleware);
            tempRequest = [middleware processRequest:tempRequest];
            if (!tempRequest) {
                *stop = YES;
            }
        }];
        if (!tempRequest) {
            [NSException raise:WQRouteMiddlewareException format:@"中间件处理失败"];
        }
        
        //路由处理
        __block exist = NO;
        [[self.handlers copy] enumerateObjectsUsingBlock:^(WQRouteHandler * _Nonnull handler, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![handler available]) {
                [self.handlers removeObject:handler];
            } else {
                if ([handler matchPattern:path]) {
                    ROUTELog(@"响应--->:%@", handler);
                    [handler performRequest:tempRequest];
                    exist = YES;
                }
            }
        }];
        if (!exist) {
            [NSException raise:WQRouteNotFoundException format:@"未匹配到处理器"];
        }
        
        return YES;
    } @catch (NSException *exception) {
        ROUTELog(@"异常--->:%@", exception);
        [request doErrorCallback:[self handleException:exception]];
        return NO;
    } @finally {
        ROUTELog(@"xxxxxxxxxxxxxxxxxxxxxxxxx路由结束xxxxxxxxxxxxxxxxxxxxxxxxx");
        ROUTELog(@"");
        ROUTELog(@"");
    }
}
- (BOOL)routeURL:(NSURL *)URL sender:(id)sender data:(nullable id)data callback:(nullable WQRouteCallbackBlock)block {
    WQRouteRequest *request = [[WQRouteRequest alloc] initWithURL:URL sender:sender data:data callback:block];
    return [self routeRequest:request];
}
- (BOOL)routeURLString:(NSString *)URLString sender:(nullable id)sender data:(nullable id)data callback:(nullable WQRouteCallbackBlock)block {
    NSString *routeUrl = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *routeURL = [NSURL URLWithString:routeUrl];
    return [self routeURL:routeURL sender:sender data:data callback:block];
}

//是否响应
- (BOOL)isResponseURL:(NSURL *)url {
    __block BOOL isResponse = NO;
    [self.handlers enumerateObjectsUsingBlock:^(WQRouteHandler * _Nonnull handler, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([handler available] && [handler matchPattern:url.absoluteString]) {
            isResponse = YES;
            *stop = YES;
        }
    }];
    return isResponse;
}
- (BOOL)isResponseURLString:(NSString *)URLString {
    NSString *routeUrl = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *routeURL = [NSURL URLWithString:routeUrl];
    return [self isResponseURL:routeURL];
}

@end

NS_ASSUME_NONNULL_END
