//
//  WQRouteRequest.m
//  WQRoute
//
//  Created by 青秀斌 on 2017/1/20.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQRouteRequest.h"

NS_ASSUME_NONNULL_BEGIN

NSExceptionName const WQRouteURLException = @"WQRouteURLException";
NSExceptionName const WQRouteNotFoundException = @"WQRouteNotFoundException";
NSExceptionName const WQRouteDispatcherException = @"WQRouteDispatcherException";
NSExceptionName const WQRouteMiddlewareException = @"WQRouteMiddlewareException";

NSErrorDomain const WQRouteErrorDomian = @"WQRouteErrorDomian";

@interface WQRouteRequest ()
@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, copy, nullable) id data;
@property (nonatomic, copy, nullable) NSArray *routeParameters;
@property (nonatomic, copy, nullable) NSDictionary *queryParameters;
@property (nonatomic, copy, nullable) WQRouteCallbackBlock callBack;
@end

@implementation WQRouteRequest

- (instancetype)initWithURL:(NSURL *)URL data:(nullable id)data
            routeParameters:(nullable NSArray *)routeParameters
            queryParameters:(nullable NSDictionary *)queryParameters
                   callBack:(nullable WQRouteCallbackBlock)block {
    if (self = [super init]) {
        self.URL = URL;
        self.data = data;
        self.routeParameters = routeParameters;
        self.queryParameters = queryParameters;
        self.callBack = block;
    }
    return self;
}
+ (instancetype)reqeustWithURL:(NSURL *)URL data:(nullable id)data
               routeParameters:(nullable NSArray *)routeParameters
               queryParameters:(nullable NSDictionary *)queryParameters
                      callBack:(nullable WQRouteCallbackBlock)block {
    return [[WQRouteRequest alloc] initWithURL:URL data:data routeParameters:routeParameters queryParameters:queryParameters callBack:block];
}

@end

NS_ASSUME_NONNULL_END
