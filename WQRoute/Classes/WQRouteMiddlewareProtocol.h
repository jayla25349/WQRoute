//
//  WQRouteMiddlewareProtocol.h
//  WQRoute
//
//  Created by 青秀斌 on 2017/1/20.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQRouteRequest.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WQRouteMiddlewareProtocol <NSObject>

@required
- (nullable WQRouteRequest *)processRequest:(WQRouteRequest *)request;

@end

NS_ASSUME_NONNULL_END
