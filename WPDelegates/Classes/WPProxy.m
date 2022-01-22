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

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _target;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    if ([_target respondsToSelector:selector]) {
        return [_target methodSignatureForSelector:selector];
    } else {
        return [self.class instanceMethodSignatureForSelector:@selector(_empty)];
    }
}

- (id)_empty {
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([_target respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:_target];
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
