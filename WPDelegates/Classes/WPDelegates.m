//
//  WPDelegates.m
//  WPDelegates
//
//  Created by steve wu on 2022/1/22.
//

#import "WPDelegates.h"
#import "WPProxy.h"

@interface WPDelegates ()

@property (nonatomic, strong) NSMutableArray<WPProxy *> *proxies;

@end

@implementation WPDelegates

- (instancetype)init {
    self = [super init];
    if (self) {
        _proxies = [NSMutableArray arrayWithCapacity:1<<7];
        NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
        [noti addObserver:self
                 selector:@selector(_trimObjectsIfReleased)
                     name:UIApplicationDidReceiveMemoryWarningNotification
                   object:nil];
    }
    return self;
}

#pragma mark - Public
- (void)addDelegate:(id)delegate {
    if (!delegate) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @synchronized (self) {
            WPProxy *pxy = [WPProxy new];
            pxy.target = delegate;
            if (![self.proxies containsObject:pxy]) {
                [self.proxies addObject:pxy];
            }
        }
    });
}

- (void)removeDelegate:(id)delegate {
    if (!delegate) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @synchronized (self) {
            for (WPProxy *pxy in self.proxies) {
                if ([delegate isEqual:pxy.target]) {
                    pxy.target = nil;
                    break;
                }
            }
        }
    });
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    @synchronized (self) {
        for (WPProxy *pxy in self.proxies) {
            if (![pxy isKindOfClass:[WPProxy class]]) {
                continue;
            }
            if (![pxy isVaild]) {
                continue;
            }
            if ([pxy respondsToSelector:aSelector]) {
                return YES;
            }
        }
    }
    return NO;
}

- (id)_empty {
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    @synchronized (self) {
        for (WPProxy *pxy in self.proxies) {
            if (![pxy isKindOfClass:[WPProxy class]]) {
                continue;
            }
            if (![pxy isVaild]) {
                continue;
            }
            if ([pxy respondsToSelector:aSelector]) {
                return [pxy methodSignatureForSelector:aSelector];
            }
        }
        return [[self class] instanceMethodSignatureForSelector:@selector(_empty)];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    @synchronized (self) {
        for (WPProxy *pxy in self.proxies) {
            if (![pxy isKindOfClass:[WPProxy class]]) {
                continue;
            }
            if (![pxy isVaild]) {
                continue;
            }
            if ([pxy respondsToSelector:invocation.selector]) {
                [invocation invokeWithTarget:pxy];
            }
        }
    }
}

- (void)_trimObjectsIfReleased {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @synchronized (self) {
            NSMutableArray *tmp = [self.proxies mutableCopy];
            [self.proxies removeAllObjects];
            for (WPProxy *pxy in tmp) {
                if (![pxy isKindOfClass:[WPProxy class]]) {
                    continue;
                }
                if (![pxy isVaild]) {
                    continue;
                }
                [self.proxies addObject:pxy];
            }
        }
    });
}

@end
