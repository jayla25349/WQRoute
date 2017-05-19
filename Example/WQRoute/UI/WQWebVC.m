
//
//  WQWebVC.m
//  WQRoute
//
//  Created by 青秀斌 on 2017/1/22.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQWebVC.h"

@interface WQWebVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSURL *reqeustURL;
@end

@implementation WQWebVC

/**********************************************************************/
#pragma mark - Service
/**********************************************************************/

+ (void)load {
    ROUTE_REGISTER(@"^testzzb://woqugame/push/webVC/$", pushTest1VC:)
}

+ (void)pushTest1VC:(WQRouteRequest *)request {
    if ([request.sender isKindOfClass:[UIViewController class]]) {
        NSURL *reqeustURL = nil;
        if ([request.data isKindOfClass:[NSURL class]]) {
            reqeustURL = request.data;
        } else if ([request.data isKindOfClass:[NSString class]]) {
            reqeustURL = [NSURL URLWithString:request.data];
        }
        
        UIViewController *lastVC = (UIViewController *)request.sender;
        WQWebVC *vc = [WQWebVC controller];
        vc.reqeustURL = reqeustURL;
        [lastVC.navigationController pushViewController:vc animated:YES];
    }
}

/**********************************************************************/
#pragma mark -
/**********************************************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *webRequest = [NSURLRequest requestWithURL:self.reqeustURL];
    [self.webView loadRequest:webRequest];
}

/**********************************************************************/
#pragma mark - UIWebViewDelegate
/**********************************************************************/

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    return !ROUTE_URL(request.URL.absoluteString, nil);
}

@end
