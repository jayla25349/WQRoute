//
//  WQRouteDispatcher.m
//  WQRoute
//
//  Created by 青秀斌 on 2017/1/22.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQRouteDispatcher.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQRouteDispatcher ()
@property (nonatomic, strong) NSRegularExpression *regular;
@property (nonatomic, strong) NSInvocation *invocation;
@property (nonatomic, weak  ) id target;
@property (nonatomic, assign) SEL selector;
@end

@implementation WQRouteDispatcher

- (nullable instancetype)initWithPattern:(NSString *)pattern target:(id)target selector:(SEL)selector {
    @try {
        NSError *error = nil;
        NSRegularExpression *reguler = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        
        NSMethodSignature *signature = [target methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = selector;
        
        if (self = [super init]) {
            self.target = target;
            self.selector = selector;
            
            self.regular = reguler;
            self.invocation = invocation;
        }
        return self;
    } @catch (NSException *exception) {
        return nil;
    }
}
+ (nullable instancetype)dispatcherWithPattern:(NSString *)pattern target:(id)target selector:(SEL)selector {
    return [[self alloc] initWithPattern:pattern target:target selector:selector];
}

- (void)performRequest:(WQRouteRequest *)request {
    if (!self.target) {
        return;
    }
    
    //注入参数
    if (self.invocation.methodSignature.numberOfArguments > 2) {
        [self.invocation setArgument:&request atIndex:2];
        
        for (NSUInteger i=3; i<self.invocation.methodSignature.numberOfArguments; i++) {
            void *argument = nil;
            if (i-3<request.routeParameters.count) {
                NSString *string = request.routeParameters[i-3];
                const char *type = [self.invocation.methodSignature getArgumentTypeAtIndex:i];
                if (strcmp(type, @encode(id)) == 0) {
                    argument = &string;
                } else if (strcmp(type, @encode(int)) == 0) {
                    int value = string.intValue;
                    argument = &value;
                } else if (strcmp(type, @encode(long)) == 0) {
                    long value = string.integerValue;
                    argument = &value;
                } else if (strcmp(type, @encode(long long)) == 0) {
                    long long value = string.longLongValue;
                    argument = &value;
                } else if (strcmp(type, @encode(float)) == 0) {
                    double value = string.floatValue;
                    argument = &value;
                } else if (strcmp(type, @encode(double)) == 0) {
                    double value = string.doubleValue;
                    argument = &value;
                } else if (strcmp(type, @encode(CGPoint)) == 0) {
                    CGPoint value = CGPointFromString(string);
                    argument = &value;
                } else if (strcmp(type, @encode(CGSize)) == 0) {
                    CGSize value = CGSizeFromString(string);
                    argument = &value;
                } else if (strcmp(type, @encode(CGRect)) == 0) {
                    CGRect value = CGRectFromString(string);
                    argument = &value;
                }
                [self.invocation setArgument:argument?:&argument atIndex:i];
            } else {
                [self.invocation setArgument:&argument atIndex:i];
            }
        }
    }
    
    //执行方法
    [self.invocation invokeWithTarget:self.target];
}

@end

NS_ASSUME_NONNULL_END
