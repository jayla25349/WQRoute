
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
@property (nonatomic, strong) WQRouteRequest *routeRequest;
@end

@implementation WQWebVC

/**********************************************************************/
#pragma mark - Service
/**********************************************************************/

+ (void)load {
    ROUTE(@"^/push/webVC/(http[s]{0,1}://\\S+)", pushTest1VC:)
}

+ (void)pushTest1VC:(WQRouteRequest *)request {
    UINavigationController *nav = (UINavigationController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    WQWebVC *vc = [WQWebVC controller];
    vc.routeRequest = request;
    [nav pushViewController:vc animated:YES];
}

/**********************************************************************/
#pragma mark -
/**********************************************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *webURL = [NSURL URLWithString:self.routeRequest.routeParameters[0]];
    NSURLRequest *webRequest = [NSURLRequest requestWithURL:webURL];
    [self.webView loadRequest:webRequest];
}

/**********************************************************************/
#pragma mark - UIWebViewDelegate
/**********************************************************************/

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    return ![[WQRouter defaultRouter] routeURL:request.URL data:nil callBack:nil];
}

@end
