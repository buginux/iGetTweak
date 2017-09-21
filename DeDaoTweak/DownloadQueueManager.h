//
//  DownloadQueueManager.h
//  DeDaoTweak
//
//  Created by 杨志超 on 2017/9/20.
//
//

#import <Foundation/Foundation.h>

@interface DownloadQueueManager : NSObject

+ (instancetype)sharedManager;

- (void)addOperation:(NSOperation *)operation;
- (void)waitUntilAllOperationsAreFinished;

@end
