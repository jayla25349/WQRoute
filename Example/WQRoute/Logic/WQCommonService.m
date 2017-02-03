//
//  WQCommonService.m
//  WQRoute
//
//  Created by 青秀斌 on 17/1/22.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQCommonService.h"

@implementation WQCommonService

/**********************************************************************/
#pragma mark - Service
/**********************************************************************/

+ (void)load {
    ROUTE(@"^/show/alert/(\\S+)/(\\S+)$", showAlert:title:message:)
    ROUTE(@"^/show/locatioin/(\\S+)$", showLocation:point:)
}

+ (void)showAlert:(WQRouteRequest *)request title:(NSString *)title message:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

+ (void)showLocation:(WQRouteRequest *)request point:(CGPoint)point{
    [SVProgressHUD showSuccessWithStatus:NSStringFromCGPoint(point)];
}

@end
