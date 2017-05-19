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
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong, nullable) id sender;
@property (nonatomic, strong, nullable) id data;
@property (nonatomic, copy,   nullable) WQRouteCallbackBlock callBack;
@property (nonatomic, strong) NSDictionary *queryParameters;
@property (nonatomic, strong) NSArray *routeParameters;
@end

@implementation WQRouteRequest

- (instancetype)initWithURL:(NSURL *)URL
                     sender:(nullable id)sender
                       data:(nullable id)data
                   callback:(nullable WQRouteCallbackBlock)block {
    if (self = [super init]) {
        self.URL = URL;
        self.sender = sender;
        self.data = data;
        self.callBack = block;
    }
    return self;
}
+ (instancetype)reqeustWithURL:(NSURL *)URL
                        sender:(nullable id)sender
                          data:(nullable id)data
                      callback:(nullable WQRouteCallbackBlock)block {
    return [[WQRouteRequest alloc] initWithURL:URL sender:sender data:data callback:block];
}

- (NSDictionary *)queryParameters {
    if (!_queryParameters) {
        _queryParameters = [NSMutableDictionary dictionary];
        
        //解析查询参数
        NSString *query = [self.URL.query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray<NSString *> *tempArray = [query componentsSeparatedByString:@"&"];
        if (tempArray.count>0) {
            [tempArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray<NSString *> *tempArray = [obj componentsSeparatedByString:@"="];
                [_queryParameters setValue:tempArray.lastObject forKey:tempArray.firstObject];
            }];
        }
    }
    return _queryParameters;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ >>> %@", self.URL, self.sender];
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (void)doResponseCallback:(nullable id)response {
    if (self.callBack) {
        self.callBack(self, response, nil);
    }
}

- (void)doErrorCallback:(nullable NSError *)error {
    if (self.callBack) {
        self.callBack(self, nil, error);
    }
}

@end

NS_ASSUME_NONNULL_END
