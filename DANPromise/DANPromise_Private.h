//
//  DANPromise_Private.h
//  DANPromise
//
//  Created by Danielle Lancashire on 10/07/2015.
//  Copyright © 2015 Rocket Apps. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DANPromiseState) {
    DANPromiseStateIncomplete = 0,
    DANPromiseStateRejected,
    DANPromiseStateFulfilled,
    DANPromiseStateCancelled
};

@interface DANPromise ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, assign) DANPromiseState state;
@property (nonatomic, strong, readonly) NSMutableArray *callbacks;

@property (nonatomic, strong) dispatch_queue_t internalQueue;

- (BOOL)bindOrPerformBlock:(dispatch_block_t)block;
- (void)performBlock:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
