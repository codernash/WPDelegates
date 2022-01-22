//
//  WPProxy.h
//  WPDelegates
//
//  Created by steve wu on 2022/1/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WPProxy : NSObject

@property (nonatomic, weak) id target;

- (BOOL)isVaild;

@end

NS_ASSUME_NONNULL_END
