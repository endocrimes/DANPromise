//
//  DANPromise.h
//  DANPromise
//
//  Created by  Danielle Lancashireon 09/07/2015.
//  Copyright (c) 2015 Rocket Apps. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@class DANPromise;

typedef void (^DANPromiseSuccessBlock)(id value);
typedef void (^DANPromiseErrorBlock)(NSError *error);
typedef void (^DANPromiseTryMapBlock)(id value, DANPromiseSuccessBlock success, DANPromiseErrorBlock failure);

@interface DANPromise : NSObject

@property (nonatomic, nullable, strong) id result;

/**
 *  If the Promise has completed with a rejection.
 */
@property (nonatomic, getter=isRejected) BOOL rejected;

/**
 *  If the Promise has completed successfully.
 */
@property (nonatomic, getter=isFulfilled) BOOL fulfilled;

/**
 *  If the promise was cancelled.
 */
@property (nonatomic, getter=isCancelled) BOOL cancelled;

/**
 *  Add a block to be called asyncronously upon fullfillment of the promise or immediately if already completed.
 */
- (DANPromise *)then:(DANPromiseSuccessBlock)then;

/**
 *  Add a block to be called asyncronously upon failure of the promise or immediately if already completed.
 */
- (DANPromise *)catch:(DANPromiseErrorBlock)error;

/**
 * Perform subsequent bindings on a given queue.
 */
- (DANPromise *)onQueue:(dispatch_queue_t)queue;

/**
 *  Attempt to map the promises value with a given block.
 */
- (DANPromise *)tryMap:(DANPromiseTryMapBlock)map;

/**
 *  Stop any actions from occuring when the Promise is fulfilled or errored.
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
