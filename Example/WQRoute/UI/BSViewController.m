//
//  BSViewController.m
//  WQRoute
//
//  Created by 青秀斌 on 17/1/21.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "BSViewController.h"

@interface BSViewController ()

@end

@implementation BSViewController

- (void)dealloc {
    NSLog(@"[%@ dealloc]", [self class]);
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

+ (instancetype)controller {
    id vc = nil;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (sb) {
        vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    }
    if (!vc) {
        vc = [[self alloc] init];
    }
    return vc;
}

@end
