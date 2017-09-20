//
//  FetchArticleListOperation.h
//  DeDaoTweak
//
//  Created by 杨志超 on 2017/9/20.
//
//

#import "AsyncOperation.h"

@interface FetchArticleListOperation : AsyncOperation

@property (nonatomic, strong) NSArray *articleIds;

- (instancetype)initWithSubscribeId:(NSNumber *)subscribeId page:(NSInteger)page;

@end
