# WQRoute

[![CI Status](http://img.shields.io/travis/jayla25349/WQRoute.svg?style=flat)](https://travis-ci.org/jayla25349/WQRoute)
[![Version](https://img.shields.io/cocoapods/v/WQRoute.svg?style=flat)](http://cocoapods.org/pods/WQRoute)
[![License](https://img.shields.io/cocoapods/l/WQRoute.svg?style=flat)](http://cocoapods.org/pods/WQRoute)
[![Platform](https://img.shields.io/cocoapods/p/WQRoute.svg?style=flat)](http://cocoapods.org/pods/WQRoute)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
This library requires iOS 7.0+ and Xcode 8.0+.

## Installation

WQRoute is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "WQRoute"
```

Then, run the following command:

```bash
$ pod install
```

## Usage

#### Registering a route

```objc
@implementation WQLoginVC

+ (void)load {
    ROUTE(@"^/present/loginVC/(\\S+)/(\\S+)$", presentLoginVC:)
    ROUTE(@"^/user/login/(\\S+)/(\\S+)$", userLogin:username:password:)
}

//The first parameter must be a WQRouteRequest
+ (void)presentLoginVC:(WQRouteRequest *)request {
    WQLoginVC *vc = [WQLoginVC controller];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [[[[UIApplication sharedApplication] delegate] window].rootViewController presentViewController:nav animated:YES completion:nil];
}

//The first parameter must be a WQRouteRequest
//WQRouter will automatic injection parameters(eg. username and password)
+ (void)userLogin:(WQRouteRequest *)request username:(NSString *)username password:(NSString *)password{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:request.queryParameters];
    [parameters setValue:username forKey:@"username"];
    [parameters setValue:password forKey:@"password"];
    [manager GET:@"http://www.baidu.com" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (request.callBack) {
            request.callBack(request, responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (request.callBack) {
            request.callBack(request, nil, error);
        }
    }];
}

@end
```

#### Registering a middleware
```objc
@implementation WQAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[WQRouter defaultRouter] registerMiddleware:[WQRouteURLVerifyMiddleware middlewareWithScheme:@"testzzb" host:@"woqugame"]];
    [[WQRouter defaultRouter] registerMiddleware:[WQRouteURLParserMiddleware new]];
    return YES;
}

@end
```

#### Calling a route

```objc
- (void)test1 {
    NSString *urlString = @"testzzb://woqugame/present/loginVC/admin/123456789/0/";
    [[WQRouter defaultRouter] routeURLString:urlString data:nil callBack:nil];
}

- (void)test2 {
    [SVProgressHUD show];
    NSString *urlString = @"testzzb://woqugame/user/login/admin/123456789";
    [[WQRouter defaultRouter] routeURLString:urlString data:nil callBack:^(WQRouteRequest * _Nonnull request, id  _Nullable response, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        } else {
            [SVProgressHUD dismiss];
            NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Test api service" message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}
```

## Author

jayla25349

## License

WQRoute is available under the MIT license. See the LICENSE file for more info.
