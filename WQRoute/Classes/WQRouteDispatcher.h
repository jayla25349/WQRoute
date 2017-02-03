//
//  WQRouteDispatcher.h
//  WQRoute
//
//  Created by 青秀斌 on 2017/1/22.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQRouteRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQRouteDispatcher : NSObject
@property (nonatomic, strong, readonly) NSRegularExpression *regular;
@property (nonatomic, weak, readonly) id target;
@property (nonatomic, assign, readonly) SEL selector;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithPattern:(NSString *)pattern target:(id)target selector:(SEL)selector;
+ (nullable instancetype)dispatcherWithPattern:(NSString *)pattern target:(id)target selector:(SEL)selector;

- (void)performRequest:(WQRouteRequest *)request;
@end
NS_ASSUME_NONNULL_END
