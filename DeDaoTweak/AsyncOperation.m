//
//  AsyncOperation.m
//  DeDaoTweak
//
//  Created by 杨志超 on 2017/9/20.
//
//

#import "AsyncOperation.h"

@interface AsyncOperation ()

@property (nonatomic, assign, getter=isReady) BOOL ready;
@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;

@end

@implementation AsyncOperation

@synthesize ready = _ready;
@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)init {
    if (self = [super init]) {
        _ready = YES;
    }
    return self;
}

- (void)setReady:(BOOL)ready {
    if (_ready != ready) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isReady))];
        _ready = ready;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isReady))];
    }
}

- (void)setExecuting:(BOOL)executing {
    if (_executing != executing) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
        _executing = executing;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
    }
}

- (void)setFinished:(BOOL)finished {
    if (_finished != finished) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
        _finished = finished;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
    }
}

- (BOOL)isAsynchronous {
    return YES;
}

- (void)start {
    if (!self.isExecuting) {
        self.ready = NO;
        self.executing = YES;
        self.finished = NO;
    }
}

- (void)finish {
    if (self.isExecuting) {
        self.executing = NO;
        self.finished = YES;
    }
}

@end
