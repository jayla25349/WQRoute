//
//  WQRouteHandler.h
//  WQRoute
//
//  Created by 青秀斌 on 2017/1/22.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQRouteRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQRouteHandler : NSObject
@property (nonatomic, weak  , readonly) id target;
@property (nonatomic, assign, readonly) SEL selector;
@property (nonatomic, strong, readonly) NSRegularExpression *regular;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithRegular:(NSRegularExpression *)regular target:(id)target selector:(SEL)selector;
+ (nullable instancetype)handlerWithRegular:(NSRegularExpression *)regular target:(id)target selector:(SEL)selector;

- (nullable instancetype)initWithPattern:(NSString *)pattern target:(id)target selector:(SEL)selector;
+ (nullable instancetype)handlerWithPattern:(NSString *)pattern target:(id)target selector:(SEL)selector;

- (BOOL)available;
- (BOOL)matchPattern:(NSString *)pattern;
- (void)performRequest:(WQRouteRequest *)request;
@end

NS_ASSUME_NONNULL_END
