//
//  WPDelegates.h
//  WPDelegates
//
//  Created by steve wu on 2022/1/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WPDelegates <NSObject>

- (void)addDelegate:(id)delegate;

- (void)removeDelegate:(id)delegate;

@end

@interface WPDelegates : NSObject <WPDelegates>

@end

NS_ASSUME_NONNULL_END
