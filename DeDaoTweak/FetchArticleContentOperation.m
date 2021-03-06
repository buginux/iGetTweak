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
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger index;

@end

@implementation FetchArticleContentOperation

- (instancetype)initWithArticleId:(NSInteger)articleId
                             page:(NSInteger)page
                            index:(NSInteger)index {
    if (self = [super init]) {
        _articleId = articleId;
        _page = page;
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
        [objc_getClass("SVProgressHUD") showWithStatus:[NSString stringWithFormat:@"下载第 %ld 页 %ld 篇文章", (long)self.page + 1, (long)self.index + 1]];
    });
    
    DataServiceV2 *dataService = [objc_getClass("DataServiceV2") GetInstance];
    [dataService FM_GetArticleContentById:self.articleId callBack:^(long long page, NSDictionary *data, BOOL success) {
        
        if (![data isKindOfClass:[NSDictionary class]] || [data count] == 0) {
            [self finish];
            return;
        }
        
        NSDictionary *article = [data objectForKey:@"c"];
        if (!article) {
            [self finish];
            return;
        }

        NSString *encodeHtml = [article objectForKey:@"encodeHtml"];
        NSString *encodekey = [article objectForKey:@"encodeKey"];

        if ([encodeHtml length] == 0 || [encodekey length] == 0) {
            [self finish];
            return;
        }
        
        NSString *articleTitle = [article objectForKey:@"article_title"];
        if ([articleTitle length] == 0) {
            articleTitle = @"未获取到文章名称";
        }

        SubscribeInfoViewModelV2 *viewModel = [objc_getClass("SubscribeInfoViewModelV2") new];
        NSString *aesKey = [viewModel getArticleAESKey:(long long)self.articleId articleSecret:encodekey];
        NSData *encodeHtmlData = [encodeHtml dataUsingEncoding:NSUTF8StringEncoding];
        NSString *content = [encodeHtmlData AES128Decrypt:aesKey];
        
        if ([self.subscribeTitle length] == 0) {
            self.subscribeTitle = @"未知专栏";
        }
        
        NSString *documentDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        
        NSString *allArticlesDirectory = [@"articles" stringByAppendingPathComponent:self.subscribeTitle];
        NSString *subscribeDirectoryPath = [documentDirectoryPath stringByAppendingPathComponent:allArticlesDirectory];
        
        BOOL createSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:subscribeDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!createSuccess) {
            [self finish];
            return;
        }
        
        NSString *filename = [NSString stringWithFormat:@"%ld-%@.html", (long)self.articleId, articleTitle];
        NSString *articleFilePath = [subscribeDirectoryPath stringByAppendingPathComponent:filename];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:articleFilePath]) {
            [content writeToFile:articleFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
        
        [self finish];
    }];
    
}

- (void)cancel {
    [super cancel];
    [self finish];
}

@end
