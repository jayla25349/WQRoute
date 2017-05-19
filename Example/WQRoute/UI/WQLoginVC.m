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
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL autoLogin;
@end

@implementation WQLoginVC

/**********************************************************************/
#pragma mark - Service
/**********************************************************************/

+ (void)load {
    ROUTE_REGISTER(@"^testzzb://woqugame/present/loginVC/(\\S+)/(\\S+)/([01])/$", presentLoginVC:username:password:autoLogin:)
    ROUTE_REGISTER(@"^testzzb://woqugame/user/login/(\\S+)/(\\S+)/$", userLogin:username:password:)
}

+ (void)presentLoginVC:(WQRouteRequest *)request username:(NSString *)username password:(NSString *)password autoLogin:(BOOL)autoLogin{
    if ([request.sender isKindOfClass:[UIViewController class]]) {
        UIViewController *lastVC = (UIViewController *)request.sender;
        WQLoginVC *vc = [WQLoginVC controller];
        vc.request = request;
        vc.username = username;
        vc.password = password;
        vc.autoLogin = autoLogin;
        
        BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:vc];
        [lastVC presentViewController:nav animated:YES completion:nil];
        [request doResponseCallback:vc];
    }
}

+ (void)userLogin:(WQRouteRequest *)request username:(NSString *)username password:(NSString *)password {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:request.queryParameters];
    [parameters setValue:username forKey:@"username"];
    [parameters setValue:password forKey:@"password"];
    [manager GET:@"http://www.baidu.com" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [request doResponseCallback:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [request doErrorCallback:error];
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
    
    self.usernameTextField.text = self.username;
    self.passwordTextField.text = self.password;
    if (self.autoLogin) {
        [self login];
    }
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)login {
    [SVProgressHUD show];
    NSString *pattern = [NSString stringWithFormat:@"testzzb://woqugame/user/login/%@/%@/",
                         self.usernameTextField.text,
                         self.passwordTextField.text];
    [ROUTE_URL_CALLBACK(pattern, nil) callback:^(WQRouteRequest * _Nonnull request, id  _Nullable response, NSError * _Nullable error) {
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
    [self.request doResponseCallback:@0];
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginAction:(id)sender {
    [self.request doResponseCallback:@1];
    [self login];
}


@end
