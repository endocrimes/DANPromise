//
//  DANTestCallback.m
//  DANPromise
//
//  Created by Daniel Tomlinson on 10/07/2015.
//  Copyright © 2015 Rocket Apps. All rights reserved.
//

#import "DANTestCallback.h"

@implementation DANTestCallback

- (DANPromiseSuccessBlock)successBlock {
    return ^(id result) {
        self.successBlockCallCount++;
    };
}

- (DANPromiseErrorBlock)errorBlock {
    return ^(NSError *error) {
        self.errorBlockCallCount++;
    };
}

@end
