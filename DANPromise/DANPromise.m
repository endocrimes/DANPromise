//
//  DANPromise.m
//  DANPromise
//
//  Created by Daniel Tomlinson on 09/07/2015.
//  Copyright (c) 2015 Rocket Apps. All rights reserved.
//

#import "DANPromise.h"
#import "DANPromise_Private.h"
#import "DANDeferredValue.h"

@implementation DANPromise

- (instancetype)init {
    self = [super init];
    if (self) {
        _callbacks = [NSMutableArray array];
        _internalQueue = dispatch_queue_create("lt.danie.promises", 0);
    }
    
    return self;
}

- (BOOL)isRejected {
    return self.state == DANPromiseStateRejected;
}

- (BOOL)isFulfilled {
    return self.state == DANPromiseStateFulfilled;
}

- (BOOL)isCancelled {
    return self.state == DANPromiseStateCancelled;
}

- (nonnull DANPromise *)then:(nonnull DANPromiseSuccessBlock)then {
    [self bindOrPerformBlock:^{
        if (self.isFulfilled && !self.isCancelled) {
            then(self.result);
        }
    }];
    
    return self;
}

- (nonnull DANPromise *)catch:(nonnull DANPromiseErrorBlock)error {
    [self bindOrPerformBlock:^{
        if (self.isRejected && !self.isCancelled) {
            error((NSError *)self.result);
        }
    }];
    
    return self;
}

- (nonnull DANPromise *)onQueue:(nonnull dispatch_queue_t)queue {
    DANDeferredValue *value = [[DANDeferredValue alloc] initWithQueue:queue];
    [self then:^(id result){
        [value fullfill:result];
    }];
    [self catch:^(NSError *error){
        [value reject:error];
    }];
    
    return [value promise];
}

- (nonnull DANPromise *)tryMap:(nonnull DANPromiseTryMapBlock)map {
    DANDeferredValue *transformedValue = [DANDeferredValue deferredValue];
    [self then:^(id result) {
        DANDeferredSuccessBlock successBlock = ^(id result) {
            [transformedValue fullfill:result];
        };
        
        DANDeferredErrorBlock errorBlock = ^(NSError *error) {
            [transformedValue reject:error];
        };
        
        map(result, successBlock, errorBlock);
    }];
    
    [self catch:^(NSError * __nonnull error) {
        [transformedValue reject:error];
    }];
    
    return [transformedValue promise];
}

- (void)cancel {
    dispatch_sync(self.internalQueue, ^{
        self.state = DANPromiseStateCancelled;
    });
}

#pragma mark - Private

- (BOOL)bindOrPerformBlock:(dispatch_block_t)block {
    __block BOOL blockWasBound = NO;

    dispatch_sync(self.internalQueue, ^{
        if (self.state == DANPromiseStateIncomplete) {
            [self.callbacks addObject:[block copy]];
            
            blockWasBound = YES;
        }
    });
    
    if (!blockWasBound) {
        [self performBlock:block];
    }
    
    return blockWasBound;
}

- (void)performBlock:(dispatch_block_t)block {
    if (self.queue) {
        dispatch_async(self.queue, block);
    }
    else {
        block();
    }
}

@end
