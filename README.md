# DANPromise
A threadsafe, lightweight implementation of Promises in Objective-C.

## Installation

I reccomend installation through CocoaPods, although you can use git submodules if you wish.
`pod 'DANPromise'`

## Usage

```
DANDeferredValue *deferred = [DANDeferredValue deferredValue];
DANPromise *promise = [deferred promise];
    
[promise then:^(id result) {
    NSLog(@"Completed with result: %@", result);
}];

[promise fullfill:@"Hello"];
```
