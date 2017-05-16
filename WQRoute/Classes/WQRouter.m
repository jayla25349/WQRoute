//
//  WQRouter.m
//  WQRoute
//
//  Created by 青秀斌 on 2017/1/20.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQRouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQRouter ()
@property (nonatomic, strong) NSMutableOrderedSet<id<WQRouteMiddlewareProtocol>> *middlewares;
@property (nonatomic, strong) NSMutableOrderedSet<WQRouteDispatcher *> *dispatchers;
@end

@implementation WQRouter

- (instancetype)init {
    if (self = [super init]) {
        self.middlewares = [NSMutableOrderedSet orderedSet];
        self.dispatchers = [NSMutableOrderedSet orderedSet];
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

//注册服务
- (void)registerPattern:(NSString *)pattern target:(id)target selector:(SEL)selector {
    WQRouteDispatcher *dispatcher = [WQRouteDispatcher dispatcherWithPattern:pattern target:target selector:selector];
    if (dispatcher) {
        [self.dispatchers addObject:dispatcher];
        ROUTELog(@"注册服务--->:%@", pattern);
    }
}

//路由
- (BOOL)routeRequest:(WQRouteRequest *)request {
    @try {
        ROUTELog(@"");
        ROUTELog(@"");
        ROUTELog(@"xxxxxxxxxxxxxxxxxxxxxxxxx路由开始(%@)xxxxxxxxxxxxxxxxxxxxxxxxx", request);
        ROUTELog(@"路由URL--->:%@", request.URL);
        NSString *path = request.URL.absoluteString;
        if (!path) {
            [NSException raise:WQRouteURLException format:@"URL错误"];
        }
        
        __block WQRouteDispatcher *dispatcher = nil;
        [[self.dispatchers copy] enumerateObjectsUsingBlock:^(WQRouteDispatcher * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!obj.target) {
                [self.dispatchers removeObject:obj];
            } else {
                if ([obj.regular numberOfMatchesInString:path options:0 range:NSMakeRange(0, path.length)]>0) {
                    dispatcher = obj;
                    *stop = YES;
                }
            }
        }];
        if (!dispatcher) {
            [NSException raise:WQRouteNotFoundException format:@"未匹配到处理器"];
        }
        
        __block WQRouteRequest *tempRequest = request;
        [self.middlewares enumerateObjectsUsingBlock:^(id<WQRouteMiddlewareProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            tempRequest = [obj processRequest:tempRequest dispatcher:dispatcher];
            if (!tempRequest) {
                *stop = YES;
            }
        }];
        if (!tempRequest) {
            [NSException raise:WQRouteMiddlewareException format:@"中间件处理失败"];
        }
        
        ROUTELog(@"匹配路由--->:%@", dispatcher.regular.pattern);
        [dispatcher performRequest:tempRequest];
        return YES;
    } @catch (NSException *exception) {
        ROUTELog(@"路由异常--->:%@", exception);
        if (request.callBack) {
            request.callBack(request, nil, [self handleException:exception]);
        }
        return NO;
    } @finally {
        ROUTELog(@"xxxxxxxxxxxxxxxxxxxxxxxxx路由结束(%@)xxxxxxxxxxxxxxxxxxxxxxxxx", request);
        ROUTELog(@"");
        ROUTELog(@"");
    }
}
- (BOOL)routeURL:(NSURL *)URL sender:(id)sender data:(nullable id)data callBack:(nullable WQRouteCallbackBlock)block {
    WQRouteRequest *request = [[WQRouteRequest alloc] initWithURL:URL
                                                           sender:sender
                                                             data:data
                                                  routeParameters:nil
                                                  queryParameters:nil
                                                         callBack:block];
    return [self routeRequest:request];
}
- (BOOL)routeURLString:(NSString *)URLString sender:(nullable id)sender data:(nullable id)data callBack:(nullable WQRouteCallbackBlock)block {
    NSString *routeUrl = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *routeURL = [NSURL URLWithString:routeUrl];
    return [self routeURL:routeURL sender:sender data:data callBack:block];
}

@end

NS_ASSUME_NONNULL_END
