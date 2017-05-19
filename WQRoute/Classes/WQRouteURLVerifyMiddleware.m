//
//  WQRouteURLVerifyMiddleware.m
//  WQRoute
//
//  Created by 青秀斌 on 17/1/21.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQRouteURLVerifyMiddleware.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQRouteURLVerifyMiddleware ()
@property (nonatomic, strong, nullable) NSString *scheme;
@property (nonatomic, strong, nullable) NSString *host;
@end

@implementation WQRouteURLVerifyMiddleware

- (instancetype)initWithScheme:(nullable NSString *)scheme host:(nullable NSString *)host {
    if (self = [super init]) {
        self.scheme = scheme;
        self.host = host;
    }
    return self;
}
+ (instancetype)middlewareWithScheme:(nullable NSString *)scheme host:(nullable NSString *)host {
    return [[WQRouteURLVerifyMiddleware alloc] initWithScheme:scheme host:host];
}

/**********************************************************************/
#pragma mark - WQRouteMiddlewareProtocol
/**********************************************************************/

- (nullable WQRouteRequest *)processRequest:(WQRouteRequest *)request {
    
    //验证URL
    if (!request.URL) {
        [NSException raise:WQRouteURLException format:@"URL不合法"];
    }
    
    //验证Scheme
    if (self.scheme && ![request.URL.scheme isEqualToString:self.scheme]) {
        [NSException raise:WQRouteURLException format:@"Scheme不合法"];
    }
    
    //验证Host
    if (self.host && ![request.URL.host isEqualToString:self.host]) {
        [NSException raise:WQRouteURLException format:@"Host不合法"];
    }
    
    return request;
}

@end

NS_ASSUME_NONNULL_END
