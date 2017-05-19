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
    ROUTE_REGISTER(@"^testzzb://woqugame/push/test1VC$", pushTest1VC:)
}

+ (void)pushTest1VC:(WQRouteRequest *)request {
    if ([request.sender isKindOfClass:[UIViewController class]]) {
        UIViewController *lastVC = (UIViewController *)request.sender;
        id vc = [self controller];
        [lastVC.navigationController pushViewController:vc animated:YES];
        [request doResponseCallback:vc];
    }
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (IBAction)vc1Action:(id)sender {
    NSString *urlString = @"testzzb://woqugame/push/test1VC";
    ROUTE_URL(urlString, nil)
}

- (IBAction)vc2Action:(id)sender {
    NSString *urlString = @"testzzb://woqugame/push/test2VC";
    ROUTE_URL(urlString, nil)
}

- (IBAction)vc3Action:(id)sender {
    NSString *urlString = @"testzzb://woqugame/push/test3VC";
    ROUTE_URL(urlString, nil)
}

- (IBAction)testAction:(id)sender {
    NSString *urlString = @"testzzb://woqugame/show/test2VC/toast?message=页面1测试";
    ROUTE_URL(urlString, nil)
}

@end
