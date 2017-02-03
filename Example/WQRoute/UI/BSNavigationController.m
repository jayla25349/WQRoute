//
//  BSNavigationController.m
//  WQRoute
//
//  Created by 青秀斌 on 17/1/21.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "BSNavigationController.h"

@interface BSNavigationController ()

@end

@implementation BSNavigationController

- (void)dealloc {
    NSLog(@"[%@ dealloc]", [self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
}

@end
