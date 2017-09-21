//
//  FetchArticleContentOperation.m
//  DeDaoTweak
//
//  Created by 杨志超 on 2017/9/21.
//
//

#import "FetchArticleContentOperation.h"
#import "DeDao.h"
#import <objc/objc-runtime.h>

@interface FetchArticleContentOperation ()

@property (nonatomic, assign) NSInteger articleId;
@property (nonatomic, assign) NSInteger index;

@end

@implementation FetchArticleContentOperation

- (instancetype)initWithArticleId:(NSInteger)articleId index:(NSInteger)index {
    if (self = [super init]) {
        _articleId = articleId;
        _index = index;
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
        [objc_getClass("SVProgressHUD") showWithStatus:[NSString stringWithFormat:@"下载第 %ld 篇文章", (long)self.index]];
    });
    
    DataServiceV2 *dataService = [objc_getClass("DataServiceV2") GetInstance];
    [dataService FM_GetArticleContentById:self.articleId callBack:^(long long page, NSDictionary *data, BOOL success) {
        
        [objc_getClass("SVProgressHUD") dismiss];
        
        NSString *message = [NSString stringWithFormat:@"%@", data];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        [self finish];
    }];
    
}

- (void)cancel {
    [super cancel];
    [self finish];
}

@end
