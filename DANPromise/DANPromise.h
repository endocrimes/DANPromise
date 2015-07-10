//
//  DANPromise.h
//  DANPromise
//
//  Created by  Danielle Lancashireon 09/07/2015.
//  Copyright (c) 2015 Rocket Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DANPromise;

typedef void (^DANPromiseSuccessBlock)(id __nonnull);
typedef void (^DANPromiseErrorBlock)(NSError *__nonnull);
typedef void (^DANPromiseTryMapBlock)(id, DANPromiseSuccessBlock, DANPromiseErrorBlock);

@interface DANPromise : NSObject

@property (nonatomic, strong) id __nullable result;

/**
 *  @return If the Promise has completed with a rejection.
 */
- (BOOL)isRejected;

/**
 *  @return If the Promise has completed successfully.
 */
- (BOOL)isFulfilled;

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

@end

NS_ASSUME_NONNULL_END
