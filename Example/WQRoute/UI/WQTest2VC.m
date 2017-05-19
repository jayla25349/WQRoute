//
//  WQTest2VC.m
//  WQRoute
//
//  Created by 青秀斌 on 17/1/21.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQTest2VC.h"

@interface WQTest2VC ()

@end

@implementation WQTest2VC

/**********************************************************************/
#pragma mark - Service
/**********************************************************************/

+ (void)load {
    ROUTE_REGISTER(@"^testzzb://woqugame/push/test2VC$", pushTest2VC:)
}

+ (void)pushTest2VC:(WQRouteRequest *)request {
    if ([request.sender isKindOfClass:[UIViewController class]]) {
        UIViewController *lastVC = (UIViewController *)request.sender;
        id vc = [self controller];
        [lastVC.navigationController pushViewController:vc animated:YES];
        [request doResponseCallback:vc];
    }
}

- (void)showToast:(WQRouteRequest *)request {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WQTest2VC"
                                                        message:request.queryParameters[@"message"]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

/**********************************************************************/
#pragma mark -
/**********************************************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ROUTE_REGISTER(@"^testzzb://woqugame/show/test2VC/toast", showToast:)
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
    NSString *urlString = @"testzzb://woqugame/show/test2VC/toast?message=页面2测试";
    ROUTE_URL(urlString, nil)
}

@end
