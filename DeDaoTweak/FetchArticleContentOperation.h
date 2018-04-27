//
//  FetchArticleContentOperation.h
//  DeDaoTweak
//
//  Created by 杨志超 on 2017/9/21.
//
//

#import "AsyncOperation.h"

/** 专栏文章内容详情 */
@interface FetchArticleContentOperation : AsyncOperation

- (instancetype)initWithArticleId:(NSInteger)articleId
                             page:(NSInteger)page
                            index:(NSInteger)index;

@property (nonatomic, strong) NSString *subscribeTitle;

@end
