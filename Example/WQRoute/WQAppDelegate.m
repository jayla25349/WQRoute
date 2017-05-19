//
//  WQAppDelegate.m
//  WQRoute
//
//  Created by jayla25349 on 02/03/2017.
//  Copyright (c) 2017 jayla25349. All rights reserved.
//

#import "WQAppDelegate.h"
#import "WQRouteLoggerMiddleware.h"

@implementation WQAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[WQRouter defaultRouter] registerMiddleware:[WQRouteURLVerifyMiddleware middlewareWithScheme:@"testzzb" host:@"woqugame"]];
    [[WQRouter defaultRouter] registerMiddleware:[WQRouteLoggerMiddleware new]];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [ROUTE_URL_CALLBACK(url.absoluteString, nil) callback:^(WQRouteRequest * _Nonnull request, id  _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString *callback = request.queryParameters[@"callback"];
            if (callback) {
                [app openURL:[NSURL URLWithString:callback]];
            }
        }
    }];
}

@end
