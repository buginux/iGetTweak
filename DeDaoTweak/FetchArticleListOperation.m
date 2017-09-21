//
//  FetchArticleListOperation.m
//  DeDaoTweak
//
//  Created by 杨志超 on 2017/9/20.
//
//

#import "FetchArticleListOperation.h"
#import "objc/objc-runtime.h"
#import "DeDao.h"

@interface FetchArticleListOperation ()

@property (nonatomic, copy) NSNumber *subscribeId;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation FetchArticleListOperation

- (instancetype)initWithSubscribeId:(NSNumber *)subscribeId
                               page:(NSInteger)page
                           pageSize:(NSInteger)pageSize {
    if (self = [super init]) {
        _subscribeId = [subscribeId copy];
        _page = page;
        _pageSize = pageSize;
    }
    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) {
        [self finish];
        return;
    }
    [self main];
}

- (void)main {
    dispatch_async(dispatch_get_main_queue(), ^{
        [objc_getClass("SVProgressHUD") showWithStatus:[NSString stringWithFormat:@"下载第 %ld 页文章列表", (long)self.page + 1]];
    });

    DataServiceV2 *dataService = [objc_getClass("DataServiceV2") GetInstance];
    [dataService FM_GetColumnArticlesByColumnId:self.subscribeId page:@(self.page) pageSize:@(self.pageSize) order:@(YES) callBack:^(long long page, NSDictionary *data, BOOL success) {
        
        if (![data isKindOfClass:[NSDictionary class]] || [data count] == 0) {
            [self finish];
            return;
        }
        
        NSArray *articles = [[data valueForKey:@"c"] valueForKey:@"articles"];
        
        if ([articles count] == 0) {
            [self finish];
            return;
        }
        
        NSArray *articleIds = [articles valueForKey:@"article_id"];
        
        if ([articleIds count] == 0) {
            [self finish];
            return;
        }
        
        self.articleIds = articleIds;
        
        [self finish];
    }];
    
}

- (void)cancel {
    [super cancel];
    [self finish];
}

@end
