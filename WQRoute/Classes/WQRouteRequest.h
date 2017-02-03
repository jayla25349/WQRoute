//
//  WQRouteRequest.h
//  WQRoute
//
//  Created by 青秀斌 on 2017/1/20.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WQRouteRequest;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSExceptionName const WQRouteURLException;
FOUNDATION_EXPORT NSExceptionName const WQRouteNotFoundException;
FOUNDATION_EXPORT NSExceptionName const WQRouteDispatcherException;
FOUNDATION_EXPORT NSExceptionName const WQRouteMiddlewareException;

FOUNDATION_EXPORT NSErrorDomain const WQRouteErrorDomian;
typedef enum {
    WQRouteUnkownError = -1000,
    WQRouteURLError = -1001,
    WQRouteNotFoundError = -1002,
    WQRouteDispatcherError = -1003,
    WQRouteMiddlewareError = -1004,
}WQRouteError;

typedef void (^WQRouteCallbackBlock)(WQRouteRequest *request, id _Nullable response, NSError * _Nullable error);

@interface WQRouteRequest : NSObject
@property (nonatomic, copy, readonly) NSURL *URL;
@property (nonatomic, copy, readonly, nullable) id data;
@property (nonatomic, copy, readonly, nullable) NSArray *routeParameters;
@property (nonatomic, copy, readonly, nullable) NSDictionary *queryParameters;
@property (nonatomic, copy, readonly, nullable) WQRouteCallbackBlock callBack;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithURL:(NSURL *)URL data:(nullable id)data
            routeParameters:(nullable NSArray *)routeParameters
            queryParameters:(nullable NSDictionary *)queryParameters
                   callBack:(nullable WQRouteCallbackBlock)block;
+ (instancetype)reqeustWithURL:(NSURL *)URL data:(nullable id)data
               routeParameters:(nullable NSArray *)routeParameters
               queryParameters:(nullable NSDictionary *)queryParameters
                      callBack:(nullable WQRouteCallbackBlock)block;
@end

NS_ASSUME_NONNULL_END
