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

- (nullable WQRouteRequest *)processRequest:(WQRouteRequest *)request {
    NSLog(@"传输参数--->:%@", request.data);
    NSLog(@"查寻参数--->:%@", request.queryParameters);
    return request;
}

@end

NS_ASSUME_NONNULL_END
