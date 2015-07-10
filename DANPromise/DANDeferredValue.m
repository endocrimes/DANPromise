//
//  DANDeferredValue.m
//  DANPromise
//
//  Created by  Danielle Lancashireon 10/07/2015.
//  Copyright © 2015 Rocket Apps. All rights reserved.
//

#import "DANDeferredValue.h"
#import "DANPromise_Private.h"

NSString *DANDeferredValueErrorDomain = @"lt.danie.DANDeferredValue";
const NSInteger DANDeferredValueNilResultError = 1000;

static NSError *NSErrorFromNilValue() {
    return [NSError errorWithDomain:DANDeferredValueErrorDomain
                               code:DANDeferredValueNilResultError
                           userInfo:@{
                                      NSLocalizedDescriptionKey: @"Unexpectedly found a nil value"
                                      }];
}

@interface DANDeferredValue ()
@end

@implementation DANDeferredValue

- (void)transitionToState:(DANPromiseState)state {
    __block NSArray *blocksToExecute = nil;
    __block BOOL shouldComplete = NO;
    
    dispatch_sync(self.internalQueue, ^{
        if (self.state == DANPromiseStateIncomplete) {
            self.state = state;
            
            shouldComplete = YES;
            
            blocksToExecute = self.callbacks;
            
            self.callbacks = nil;
        }
    });
    
    if (shouldComplete) {
        for (dispatch_block_t block in blocksToExecute) {
            [self performBlock:block];
        }
    }
}

- (nonnull instancetype)init {
    self = [super init];
    if (self) {
        self.state = DANPromiseStateIncomplete;
    }
    
    return self;
}

- (nonnull instancetype)initWithQueue:(dispatch_queue_t __nonnull)queue {
    self = [self init];
    if (self) {
        self.queue = queue;
    }
    
    return self;
}

+ (nonnull instancetype)deferredValue {
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
