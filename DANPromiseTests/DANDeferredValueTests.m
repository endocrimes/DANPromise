//
//  DANDeferredValueTests.m
//  DANPromise
//
//  Created by Daniel Tomlinson on 10/07/2015.
//  Copyright © 2015 Rocket Apps. All rights reserved.
//

@import XCTest;

#import "DANDeferredValue.h"
#import "DANPromise_Private.h"

@interface DANDeferredValueTests : XCTestCase

@end

@implementation DANDeferredValueTests

- (void)test_creatingADeferredValue_withAnExecutorBlock_usingDeferredValueWithExecutor {
    DANDeferredExecutorBlock executor = ^(DANPromiseSuccessBlock success, DANPromiseErrorBlock error) {};
    DANDeferredValue *deferredValue = [DANDeferredValue deferredValueWithExecutor:executor];
    
    XCTAssertNotNil(deferredValue);
}

- (void)test_fullfill_resultsIn_successful_completion {
    XCTestExpectation *expectation = [self expectationWithDescription:@"The bound block should be triggered"];
    
    DANDeferredValue *deferredValue = [DANDeferredValue deferredValue];
    [deferredValue bindOrPerformBlock:^{
        XCTAssertTrue(deferredValue.state == DANPromiseStateFulfilled);
        [expectation fulfill];
    }];
    
    [deferredValue fullfill:@1];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_reject_resultsIn_error_completion {
    XCTestExpectation *expectation = [self expectationWithDescription:@"The bound block should be triggered"];
    
    DANDeferredValue *deferredValue = [DANDeferredValue deferredValue];
    [deferredValue bindOrPerformBlock:^{
        XCTAssertTrue(deferredValue.state == DANPromiseStateRejected);
        [expectation fulfill];
    }];
    
    [deferredValue reject:[NSError errorWithDomain:@"testdomain" code:100 userInfo:nil]];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_promise_isNot_nil {
    DANDeferredValue *deferredValue = [DANDeferredValue deferredValue];
    DANPromise *promise = [deferredValue promise];
    
    XCTAssertNotNil(promise);
}

@end
