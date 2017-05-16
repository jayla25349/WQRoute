//
//  WQRouteURLParserMiddleware.m
//  WQRoute
//
//  Created by 青秀斌 on 2017/1/20.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQRouteURLParserMiddleware.h"

NS_ASSUME_NONNULL_BEGIN

@implementation WQRouteURLParserMiddleware

/**********************************************************************/
#pragma mark - WQRouteMiddlewareProtocol
/**********************************************************************/

- (nullable WQRouteRequest *)processRequest:(WQRouteRequest *)request dispatcher:(nonnull WQRouteDispatcher *)dispatcher {
    
    //解析查询参数
    NSString *query = request.URL.query;
    query = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray<NSString *> *tempArray = [query componentsSeparatedByString:@"&"];
    if (tempArray.count>0) {
        NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionary];
        [tempArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray<NSString *> *tempArray = [obj componentsSeparatedByString:@"="];
            [tempDictionary setValue:tempArray.lastObject forKey:tempArray.firstObject];
        }];
        request = [[WQRouteRequest alloc] initWithURL:request.URL
                                               sender:request.sender
                                                 data:request.data
                                      routeParameters:request.routeParameters
                                      queryParameters:tempDictionary.count>0?tempDictionary:nil
                                             callBack:request.callBack];
    }
    
    //解析路由参数
    NSString *path = request.URL.path;
    NSTextCheckingResult *result = [dispatcher.regular firstMatchInString:path options:0 range:NSMakeRange(0, path.length)];
    if (result) {
        NSMutableArray *parameters = [NSMutableArray array];
        for (NSUInteger i=1; i<result.numberOfRanges; i++) {
            NSRange range = [result rangeAtIndex:i];
            NSString *string = [path substringWithRange:range];
            [parameters addObject:string];
        }
        request = [[WQRouteRequest alloc] initWithURL:request.URL
                                               sender:request.sender
                                                 data:request.data
                                      routeParameters:parameters.count>0?parameters:nil
                                      queryParameters:request.queryParameters
                                             callBack:request.callBack];
    }
    
    return request;
}

@end

NS_ASSUME_NONNULL_END
