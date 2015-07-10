//
//  DANDeferredValue.m
//  DANPromise
//
//  Created by Daniel Tomlinson on 10/07/2015.
//  Copyright © 2015 Rocket Apps. All rights reserved.
//

#import "DANDeferredValue.h"
#import "DANPromise_Private.h"

NSString *DANDeferredValueErrorDomain = @"lt.danie.DANDeferredValue";
const NSInteger DANDeferredValueNilResultError = 1000;

static NSError *NSErrorFromNilValue() {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Unexpectedly found a nil value"};
    return [NSError errorWithDomain:DANDeferredValueErrorDomain
                               code:DANDeferredValueNilResultError
                           userInfo:userInfo];
}

@implementation DANDeferredValue

- (void)transitionToState:(DANPromiseState)state {
    __block NSArray *blocksToExecute = nil;
    __block BOOL shouldComplete = NO;
    
    dispatch_sync(self.internalQueue, ^{
        if (self.state == DANPromiseStateIncomplete) {
            self.state = state;
            
            shouldComplete = YES;
            
            blocksToExecute = [self.callbacks copy];
            
            [self.callbacks removeAllObjects];
        }
    });
    
    if (shouldComplete) {
        for (dispatch_block_t block in blocksToExecute) {
            [self performBlock:block];
        }
    }
}

- (instancetype)init {
    return [self initWithQueue:nil];
}

- (instancetype)initWithQueue:(nullable dispatch_queue_t)queue {
    self = [self init];

    self.state = DANPromiseStateIncomplete;
    self.queue = queue;
    
    return self;
}

+ (instancetype)deferredValue {
    return [[self alloc] init];
}

+ (nonnull instancetype)deferredValueWithExecutor:(nonnull DANDeferredExecutorBlock)executor {
    DANDeferredValue *deferredValue = [DANDeferredValue deferredValue];
    [deferredValue performBlock:^{
        DANDeferredSuccessBlock success = ^(id theValue) {
            [deferredValue fullfill:theValue];
        };
        
        DANDeferredErrorBlock error = ^(NSError *theError) {
            [deferredValue reject:theError];
        };
        
        executor(success, error);
    }];
    
    
    return deferredValue;
}

- (DANPromise *)fullfill:(nullable id)value {
    self.result = value;
    
    if (value == nil) {
        [self reject:NSErrorFromNilValue()];
        return [self promise];
    }
    
    [self transitionToState:DANPromiseStateFulfilled];
    return [self promise];
}

- (DANPromise *)reject:(nonnull NSError *)error {
    self.result = error;
    [self transitionToState:DANPromiseStateRejected];
    return [self promise];
}

- (nonnull DANPromise *)promise {
    return self;
}

@end
