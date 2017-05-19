//
//  WQRouteHandler.m
//  WQRoute
//
//  Created by 青秀斌 on 2017/1/22.
//  Copyright © 2017年 woqugame. All rights reserved.
//

#import "WQRouteHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQRouteHandler ()
@property (nonatomic, weak  ) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) NSRegularExpression *regular;
@property (nonatomic, strong) NSInvocation *invocation;
@end

@implementation WQRouteHandler

- (nullable instancetype)initWithRegular:(NSRegularExpression *)regular target:(id)target selector:(SEL)selector{
    if (!regular || !target || ![target respondsToSelector:selector]) {
        return nil;
    }
    
    @try {
        NSMethodSignature *signature = [target methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = selector;
        
        if (self = [super init]) {
            self.regular = regular;
            self.target = target;
            self.selector = selector;
            self.invocation = invocation;
        }
        return self;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (nullable instancetype)handlerWithRegular:(NSRegularExpression *)regular target:(id)target selector:(SEL)selector {
    return [[WQRouteHandler alloc] initWithRegular:regular target:target selector:selector];
}

- (nullable instancetype)initWithPattern:(NSString *)pattern target:(id)target selector:(SEL)selector {
    NSRegularExpression *reguler = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    return [self initWithRegular:reguler target:target selector:selector];
}
+ (nullable instancetype)handlerWithPattern:(NSString *)pattern target:(id)target selector:(SEL)selector {
    return [[WQRouteHandler alloc] initWithPattern:pattern target:target selector:selector];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ >>> [%@ %@]",
            self.regular.pattern,
            self.target,
            NSStringFromSelector(self.invocation.selector)];
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (BOOL)available {
    if (self.target) {
        return YES;
    }
    return NO;
}

- (BOOL)matchPattern:(NSString *)pattern {
    if ([self.regular numberOfMatchesInString:pattern options:0 range:NSMakeRange(0, pattern.length)]>0) {
        return YES;
    }
    return NO;
}

- (void)performRequest:(WQRouteRequest *)request {
    if (!request || !self.target) {
        return;
    }
    
    //注入参数
    if (self.invocation.methodSignature.numberOfArguments > 2) {
        [self.invocation setArgument:&request atIndex:2];
    }
    
    //注入参数
    NSMutableArray *parameters = nil;
    if (self.invocation.methodSignature.numberOfArguments > 3) {
        
        //解析路由参数
        NSString *path = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSTextCheckingResult *result = [self.regular firstMatchInString:path options:0 range:NSMakeRange(0, path.length)];
        if (result) {
            parameters = [NSMutableArray array];
            for (NSUInteger i=1; i<result.numberOfRanges; i++) {
                NSRange range = [result rangeAtIndex:i];
                NSString *string = [path substringWithRange:range];
                [parameters addObject:string];
            }
        }
        
        for (NSUInteger i=3; i<self.invocation.methodSignature.numberOfArguments; i++) {
            void *argument = nil;
            if (i-3<parameters.count) {
                NSString *string = parameters[i-3];
                const char *type = [self.invocation.methodSignature getArgumentTypeAtIndex:i];
                if (strcmp(type, @encode(id)) == 0) {
                    argument = &string;
                } else if (strcmp(type, @encode(BOOL)) == 0) {
                    BOOL value = string.boolValue;
                    argument = &value;
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
                } else {
                    argument = &argument;
                }
                [self.invocation setArgument:argument atIndex:i];
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
