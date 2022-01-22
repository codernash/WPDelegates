//
//  WPDelegates.m
//  WPDelegates
//
//  Created by steve wu on 2022/1/22.
//

#import "WPDelegates.h"
#import <pthread/pthread.h>
#import <WPDelegates/WPProxy.h>

@interface WPDelegates ()
{
    pthread_mutex_t mutex_;
}

@property (nonatomic, strong) NSMutableArray<WPProxy *> *proxies;

@end

@implementation WPDelegates

- (instancetype)init {
    self = [super init];
    if (self) {
        {
            pthread_mutexattr_t attr;
            pthread_mutexattr_init(&attr);
            pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);

            pthread_mutex_init(&mutex_, &attr);
            pthread_mutexattr_destroy(&attr);
        }
        
        self.proxies = [NSMutableArray arrayWithCapacity:1<<7];
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
    pthread_mutex_lock(&mutex_);
    WPProxy *pxy = [WPProxy new];
    pxy.target = delegate;
    if (![self.proxies containsObject:pxy]) {
        [self.proxies addObject:pxy];
    }
    pthread_mutex_unlock(&mutex_);
}

- (void)removeDelegate:(id)delegate {
    if (!delegate) {
        return;
    }
    pthread_mutex_lock(&mutex_);
    for (WPProxy *pxy in self.proxies) {
        if ([delegate isEqual:pxy.target]) {
            pxy.target = nil;
            break;
        }
    }
    pthread_mutex_unlock(&mutex_);
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL flg = NO;
    pthread_mutex_lock(&mutex_);
    for (WPProxy *pxy in self.proxies) {
        if (![pxy isKindOfClass:[WPProxy class]]) {
            continue;
        }
        if (![pxy isVaild]) {
            continue;
        }
        if ([pxy respondsToSelector:aSelector]) {
            flg = YES;
            break;
        }
    }
    pthread_mutex_unlock(&mutex_);
    return flg;
}

- (id)_empty {
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    pthread_mutex_lock(&mutex_);
    NSMethodSignature *sign;
    for (WPProxy *pxy in self.proxies) {
        if (![pxy isKindOfClass:[WPProxy class]]) {
            continue;
        }
        if (![pxy isVaild]) {
            continue;
        }
        if ([pxy respondsToSelector:aSelector]) {
            sign = [pxy methodSignatureForSelector:aSelector];
            break;
        }
    }
    pthread_mutex_unlock(&mutex_);
    if (!sign) {
        return [[self class] instanceMethodSignatureForSelector:@selector(_empty)];
    } else {
        return sign;
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    pthread_mutex_lock(&mutex_);
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
    pthread_mutex_unlock(&mutex_);
}

- (void)_trimObjectsIfReleased {
    pthread_mutex_lock(&mutex_);
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
    pthread_mutex_unlock(&mutex_);
}

@end
