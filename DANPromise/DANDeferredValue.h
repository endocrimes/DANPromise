//
//  DANDeferredValue.h
//  DANDeffered
//
//  Created by Danielle Lancashire on 10/07/2015.
//  Copyright © 2015 Rocket Apps. All rights reserved.
//

@import Foundation;

#import "DANPromise.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *DANDeferredValueErrorDomain;
extern const NSInteger DANDeferredValueNilResultError;

typedef void (^DANDeferredSuccessBlock)(id value);
typedef void (^DANDeferredErrorBlock)(NSError *error);
typedef void (^DANDeferredExecutorBlock)(DANDeferredSuccessBlock success, DANDeferredErrorBlock failure);

@interface DANDeferredValue : DANPromise

/**
 *  Create a new DANDeferredValue with no attached queue.
 */
- (instancetype)init;

/**
 * Create a new DANDeferredValue that executes on a given queue.
 */
- (instancetype)initWithQueue:(nullable dispatch_queue_t)queue NS_DESIGNATED_INITIALIZER;

/**
 *  Create a new DANDeferredValue with no attached queue.
 */
+ (instancetype)deferredValue;

/**
 *  Create a new DANDeferredValue with no attached queue and an asyncronous executor block. The executor will be called
 *  automatically, and the callbacks will handle fullfillment and rejection of the DeferredValue.
 */
+ (instancetype)deferredValueWithExecutor:(DANDeferredExecutorBlock)executor;

/**
 *  Fullfill the Promise with a given value. Although it is safe to call this method multiple times, only the first 
 *  value will be used.
 */
- (DANPromise *)fullfill:(nullable id)value;

/**
 *  Reject the Promise with a given error. Although it is safe to call this method multiple times, only the first
 *  error will be used.
 */
- (DANPromise *)reject:(NSError *)error;

/**
 *  Return a DANPromise from the DANDefferedValue.
 */
- (DANPromise *)promise;

@end

NS_ASSUME_NONNULL_END
