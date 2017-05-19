//
//  WQHomeVC.m
//  WQRoute
//
//  Created by 青秀斌 on 17/1/21.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQHomeVC.h"

@interface WQHomeVC ()

@end

@implementation WQHomeVC

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *urlString = nil;
    switch (indexPath.row) {
        case 0:{
            urlString = @"testzzb://woqugame/show/alert/这是标题/这是消息内容";
            //            urlString = @"testzzb://woqugame/show/locatioin/{1,234}";
            ROUTE_URL(urlString, nil)
        }break;
        case 1:{
            urlString = @"testzzb://woqugame/push/test1VC";
            ROUTE_URL(urlString, nil)
        }break;
        case 2:{
            urlString = @"testzzb://woqugame/push/webVC/";
            ROUTE_URL(urlString, @"http://www.kylincc.com")
        }break;
        case 3:{
            urlString = @"testzzb://woqugame/present/loginVC/admin/123456789/0/";
            ROUTE_URL(urlString, nil)
        }break;
        case 4:{
            [SVProgressHUD show];
            urlString = @"testzzb://woqugame/user/login/admin/123456789/";
            [ROUTE_URL_CALLBACK(urlString, nil) callback:^(WQRouteRequest * _Nonnull request, id  _Nullable response, NSError * _Nullable error) {
                if (error) {
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                } else {
                    [SVProgressHUD dismiss];
                    NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"接口数据"
                                                                        message:string
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }];
        }break;
    }
}

@end
