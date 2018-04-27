//
//  FetchLessonContentOperation.m
//  DeDaoTweak
//
//  Created by buginux on 2018/4/27.
//

#import "FetchLessonContentOperation.h"
#import "DeDao.h"
#import <objc-runtime.h>

@interface FetchLessonContentOperation ()

@property (nonatomic, strong) NSString *audioId;
@property (nonatomic, strong) NSString *title;

@end

@implementation FetchLessonContentOperation

- (instancetype)initWithAudioId:(NSString *)audioId title:(NSString *)title {
    if (self = [super init]) {
        _audioId = audioId;
        _title = title;
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
        [objc_getClass("SVProgressHUD") showWithStatus:@"文章下载中..."];
    });
    
    
    DDFreeColumnArticleApi *articleApi = [objc_getClass("DDFreeColumnArticleApi") new];
    articleApi.audioIndentify = self.audioId;
    
    [articleApi startWithCompletionBlockWithSuccess:^(DDBaseRequest *baseRequest) {
        NSDictionary *responseObject = baseRequest.responseObject;
        if (![responseObject isKindOfClass:[NSDictionary class]] || [responseObject count] == 0) {
            [self finish];
            return;
        }
        
        NSDictionary *lesson = [responseObject objectForKey:@"c"];
        if (!lesson) {
            [self finish];
            return;
        }
        
        NSString *lessonTitle = [lesson objectForKey:@"column_name"];
        if ([lessonTitle length] == 0) {
            lessonTitle = @"未获取到精品课名称";
        }
        
        NSString *content = [lesson valueForKeyPath:@"content.content"];
        NSString *documentDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        
        NSString *allArticlesDirectory = [@"articles" stringByAppendingPathComponent:lessonTitle];
        NSString *lessonDirectoryPath = [documentDirectoryPath stringByAppendingPathComponent:allArticlesDirectory];
        
        BOOL createSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:lessonDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!createSuccess) {
            [self finish];
            return;
        }
        
        NSString *filename = [NSString stringWithFormat:@"%@-%@.html", self.audioId, self.title];
        NSString *articleFilePath = [lessonDirectoryPath stringByAppendingPathComponent:filename];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:articleFilePath]) {
            [content writeToFile:articleFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
        
        [self finish];
    } failure:^(DDBaseRequest *baseRequest) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = [NSString stringWithFormat:@"文章 %@ 下载错误...", self.audioId];
            [objc_getClass("SVProgressHUD") showWithStatus:message];
            [self finish];
        });
    }];
}

- (void)cancel {
    [super cancel];
    [self finish];
}

@end
