//
//  WQLoginVC.m
//  WQRoute
//
//  Created by 青秀斌 on 2017/1/21.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQLoginVC.h"

@interface WQLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) WQRouteRequest *request;
@end

@implementation WQLoginVC

/**********************************************************************/
#pragma mark - Service
/**********************************************************************/

+ (void)load {
    ROUTE(@"^/present/loginVC/(\\S+)/(\\S+)/([01])$", presentLoginVC:)
    ROUTE(@"^/user/login/(\\S+)/(\\S+)$", userLogin:username:password:)
}

+ (void)presentLoginVC:(WQRouteRequest *)request {
    WQLoginVC *vc = [WQLoginVC controller];
    vc.request = request;
    BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:vc];
    [[[[UIApplication sharedApplication] delegate] window].rootViewController presentViewController:nav animated:YES completion:nil];
}

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

/**********************************************************************/
#pragma mark -
/**********************************************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户登录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self action:@selector(cancelAction:)];
    
    self.usernameTextField.text = self.request.routeParameters[0];
    self.passwordTextField.text = self.request.routeParameters[1];
    if ([self.request.routeParameters[2] boolValue]) {
        [self login];
    }
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)login {
    [SVProgressHUD show];
    NSString *pattern = [NSString stringWithFormat:@"testzzb://woqugame/user/login/%@/%@",
                         self.usernameTextField.text,
                         self.passwordTextField.text];
    [[WQRouter defaultRouter] routeURLString:pattern data:nil callBack:^(WQRouteRequest * _Nonnull request, id  _Nullable response, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (void)cancelAction:(id)sender {
    if (self.request.callBack) {
        self.request.callBack(self.request, @0, nil);
    }
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginAction:(id)sender {
    if (self.request.callBack) {
        self.request.callBack(self.request, @1, nil);
    }
    [self login];
}


@end
