//
//  FetchArticleListOperation.h
//  DeDaoTweak
//
//  Created by 杨志超 on 2017/9/20.
//
//

#import "AsyncOperation.h"

/** 专栏文章列表 */
@interface FetchArticleListOperation : AsyncOperation

@property (nonatomic, strong) NSArray *articleIds;

- (instancetype)initWithSubscribeId:(NSNumber *)subscribeId
                               page:(NSInteger)page
                           pageSize:(NSInteger)pageSize;

@end
