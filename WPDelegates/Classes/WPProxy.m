//
//  WPProxy.m
//  WPDelegates
//
//  Created by steve wu on 2022/1/22.
//

#import "WPProxy.h"

@implementation WPProxy

- (BOOL)isVaild {
    return _target != nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    if ([self respondsToSelector:selector]) {
        return [_target methodSignatureForSelector:selector];
    } else {
        return [self.class instanceMethodSignatureForSelector:@selector(_empty)];
    }
}

- (id)_empty { return nil; }

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([self respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:_target];
    } else {
        void *null = NULL;
        [invocation setReturnValue:&null];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}

- (BOOL)isEqual:(WPProxy *)object {
    return [_target isEqual:object.target];
}

- (NSUInteger)hash {
    return [_target hash];
}

@end
