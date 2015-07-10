# DANPromise

A thread-safe, lightweight implementation of promises in Objective-C.

## Installation

Installation through CocoaPods is recommended, although one may use git submodules too.

```ruby
pod 'DANPromise'
```

## Usage

```objc
DANDeferredValue *deferred = [DANDeferredValue deferredValue];
DANPromise *promise = [deferred promise];
    
[promise then:^(id result) {
    NSLog(@"Completed with result: %@", result);
}];

[promise fullfill:@"Hello"];
```
