//
//  WQTest1VC.m
//  WQRoute
//
//  Created by 青秀斌 on 17/1/21.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQTest1VC.h"

@interface WQTest1VC ()

@end

@implementation WQTest1VC

/**********************************************************************/
#pragma mark - Service
/**********************************************************************/

+ (void)load {
    ROUTE(@"^/push/test1VC$", pushTest1VC:)
}

+ (void)pushTest1VC:(WQRouteRequest *)request {
    UINavigationController *nav = (UINavigationController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    id vc = [self controller];
    [nav pushViewController:vc animated:YES];
    if (request.callBack) {
        request.callBack(request, nil, nil);
    }
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (IBAction)vc1Action:(id)sender {
    NSString *urlString = @"testzzb://woqugame/push/test1VC";
    [[WQRouter defaultRouter] routeURLString:urlString data:nil callBack:nil];
}

- (IBAction)vc2Action:(id)sender {
    NSString *urlString = @"testzzb://woqugame/push/test2VC";
    [[WQRouter defaultRouter] routeURLString:urlString data:nil callBack:nil];
}

- (IBAction)vc3Action:(id)sender {
    NSString *urlString = @"testzzb://woqugame/push/test3VC";
    [[WQRouter defaultRouter] routeURLString:urlString data:nil callBack:nil];
}

- (IBAction)testAction:(id)sender {
    NSString *urlString = @"testzzb://woqugame/show/test2VC/toast?message=页面1测试";
    [[WQRouter defaultRouter] routeURLString:urlString data:nil callBack:nil];
}

@end
