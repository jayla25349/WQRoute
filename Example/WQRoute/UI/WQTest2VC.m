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
    ROUTE(@"^/push/test2VC$", pushTest2VC:)
}

+ (void)pushTest2VC:(WQRouteRequest *)request {
    UINavigationController *nav = (UINavigationController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    id vc = [self controller];
    [nav pushViewController:vc animated:YES];
    if (request.callBack) {
        request.callBack(request, nil, nil);
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
    
    ROUTE(@"^/show/test2VC/toast", showToast:)
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
    NSString *urlString = @"testzzb://woqugame/show/test2VC/toast?message=页面2测试";
    [[WQRouter defaultRouter] routeURLString:urlString data:nil callBack:nil];
}

@end
