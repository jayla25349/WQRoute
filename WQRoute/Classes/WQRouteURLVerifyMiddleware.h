//
//  WQRouteURLVerifyMiddleware.h
//  WQRoute
//
//  Created by 青秀斌 on 17/1/21.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQRouteMiddlewareProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQRouteURLVerifyMiddleware : NSObject<WQRouteMiddlewareProtocol>
@property (nonatomic, readonly, nullable) NSString *scheme;
@property (nonatomic, readonly, nullable) NSString *host;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithScheme:(nullable NSString *)scheme host:(nullable NSString *)host;
+ (instancetype)middlewareWithScheme:(nullable NSString *)scheme host:(nullable NSString *)host;

@end

NS_ASSUME_NONNULL_END
