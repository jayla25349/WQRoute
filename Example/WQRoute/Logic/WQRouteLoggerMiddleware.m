//
//  WQRouteLoggerMiddleware.m
//  WQRoute
//
//  Created by 青秀斌 on 17/1/21.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQRouteLoggerMiddleware.h"

@implementation WQRouteLoggerMiddleware

NS_ASSUME_NONNULL_BEGIN

- (nullable WQRouteRequest *)processRequest:(WQRouteRequest *)request dispatcher:(WQRouteDispatcher *)dispatcher {
    ROUTELog(@"传输参数--->:%@", request.data);
    ROUTELog(@"路由参数--->:%@", request.routeParameters);
    ROUTELog(@"查寻参数--->:%@", request.queryParameters);
    return request;
}

@end

NS_ASSUME_NONNULL_END
