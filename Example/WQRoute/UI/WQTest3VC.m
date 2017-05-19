//
//  WQTest3VC.m
//  WQRoute
//
//  Created by 青秀斌 on 17/1/21.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQTest3VC.h"

@interface WQTest3VC ()

@end

@implementation WQTest3VC

/**********************************************************************/
#pragma mark - Service
/**********************************************************************/

+ (void)load {
    ROUTE_REGISTER(@"^testzzb://woqugame/push/test3VC$", pushTest3VC:)
}

+ (void)pushTest3VC:(WQRouteRequest *)request {
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
    NSString *urlString = @"testzzb://woqugame/show/test2VC/toast?message=页面3测试";
    ROUTE_URL(urlString, nil)
}

@end
