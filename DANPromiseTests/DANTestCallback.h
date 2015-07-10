//
//  DANTestCallback.h
//  DANPromise
//
//  Created by Daniel Tomlinson on 10/07/2015.
//  Copyright © 2015 Rocket Apps. All rights reserved.
//

@import Foundation;

#import "DANPromise.h"

@interface DANTestCallback : NSObject

@property (nonatomic, copy) DANPromiseSuccessBlock successBlock;
@property (nonatomic, copy) DANPromiseErrorBlock errorBlock;

@property (nonatomic, assign) NSInteger successBlockCallCount;
@property (nonatomic, assign) NSInteger errorBlockCallCount;

@end
