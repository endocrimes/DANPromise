//
//  DANPromiseTests.m
//  DANPromise
//
//  Created by  Danielle Lancashireon 09/07/2015.
//  Copyright (c) 2015 Rocket Apps. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DANDeferredValue.h"
#import "DANPromise.h"
#import "DANPromise_Private.h"
#import "DANTestCallback.h"

@interface DANPromiseTests : XCTestCase
@property (nonatomic, strong) DANTestCallback *callback;
@end

@implementation DANPromiseTests

- (void)setUp {
    [super setUp];
    self.callback = [DANTestCallback new];
}

- (void)tearDown {
    [super tearDown];
    self.callback = nil;
}

- (void)test_then {
    DANDeferredValue *deferred = [DANDeferredValue deferredValue];
    DANPromise *promise = [deferred promise];
    
    [promise then:self.callback.successBlock];
    
    XCTAssertEqual(self.callback.successBlockCallCount, 0, @"then: not called prematurely");
    
    [deferred fullfill:@YES];
    
    XCTAssertEqual(self.callback.successBlockCallCount, 1, @"then: should be called");
}

- (void)test_catch {
    DANDeferredValue *deferred = [DANDeferredValue deferredValue];
    DANPromise *promise = [deferred promise];
    
    [promise catch:self.callback.errorBlock];
    
    XCTAssertEqual(self.callback.errorBlockCallCount, 0, @"catch: not called prematurely");
    
    [deferred reject:[NSError errorWithDomain:@"lt.danie.promise.tests" code:100 userInfo:nil]];
    
    XCTAssertEqual(self.callback.errorBlockCallCount, 1, @"error: should be called");
}

- (void)test_fullfilled_once {
    DANDeferredValue *deferred = [DANDeferredValue deferredValue];
    DANPromise *promise = [deferred promise];
    
    [promise then:self.callback.successBlock];
    [promise catch:self.callback.errorBlock];
    
    XCTAssertEqual(self.callback.successBlockCallCount, 0, @"then: not called prematurely");
    
    [deferred fullfill:@YES];
    
    XCTAssertEqual(self.callback.successBlockCallCount, 1, @"then: should be called");
    
    [deferred fullfill:@YES];
    
    XCTAssertEqual(self.callback.successBlockCallCount, 1, @"then: should only be called once");
    
    [deferred reject:[NSError errorWithDomain:@"lt.danie.promise.tests" code:100 userInfo:nil]];
    
    XCTAssertEqual(self.callback.errorBlockCallCount, 0, @"Promise should not change state");
    XCTAssertEqual(self.callback.successBlockCallCount, 1, @"Promise should not change state");
}

- (void)test_promise_is_called_immediately_ifAlreadyFulfilled {
    DANDeferredValue *deferred = [DANDeferredValue deferredValue];
    DANPromise *promise = [deferred promise];
    
    [deferred fullfill:@YES];
    
    [promise then:self.callback.successBlock];
    XCTAssertEqual(self.callback.successBlockCallCount, 1, @"Should be called immediately.");
}

- (void)test_resolve_only_calls_then_block {
    DANDeferredValue *deferred = [DANDeferredValue deferredValue];
    DANPromise *promise = [deferred promise];
    
    [promise then:self.callback.successBlock];
    [promise catch:self.callback.errorBlock];
    
    XCTAssertEqual(self.callback.successBlockCallCount, 0, @"when not called synchronously");
    XCTAssertEqual(self.callback.errorBlockCallCount, 0, @"Failed not called");
    
    [deferred fullfill:@"This is a test"];
    
    XCTAssertEqual(self.callback.successBlockCallCount, 1, @"then: should be called");
    XCTAssertEqual(self.callback.errorBlockCallCount, 0, @"catch: should not be called");
}

- (void)test_returns_correct_value_when_executing_asyncronously {
    DANDeferredValue *deferred = [DANDeferredValue deferredValue];
    DANPromise *promise = [deferred promise];
    NSString *value = @"Hello!";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Should fullfil with correct value"];
    
    [promise then:^(id theValue) {
        XCTAssertEqualObjects(value, theValue);
        
        [expectation fulfill];
    }];
    
    [deferred fullfill:value];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_returns_correct_value_when_executing_syncronously {
    DANDeferredValue *deferred = [DANDeferredValue deferredValue];
    DANPromise *promise = [deferred promise];
    NSString *value = @"Hello!";
    __block NSString *outputValue;
    
    [deferred fullfill:value];
    
    [promise then:^(id theValue) {
        outputValue = theValue;
    }];
    
    XCTAssertEqualObjects(value, outputValue);
}

@end
