//
//  DownloadQueueManager.m
//  DeDaoTweak
//
//  Created by 杨志超 on 2017/9/20.
//
//

#import "DownloadQueueManager.h"

@interface DownloadQueueManager ()

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation DownloadQueueManager

+ (instancetype)sharedManager {
    static DownloadQueueManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DownloadQueueManager new];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _queue = [NSOperationQueue new];
        _queue.name = @"DownloadQueue";
        _queue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)addOperation:(NSOperation *)operation {
    [self.queue addOperation:operation];
}


@end
