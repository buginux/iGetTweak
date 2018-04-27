//
//  FetchLessonListOperation.m
//  DeDaoTweak
//
//  Created by buginux on 2018/4/27.
//

#import "FetchLessonListOperation.h"
#import <objc-runtime.h>
#import "DeDao.h"

@interface FetchLessonListOperation ()

@property (nonatomic, strong) NSString *subjectId;

@end

@implementation FetchLessonListOperation

- (instancetype)initWithSubjectId:(NSString *)subjectId {
    if (self = [super init]) {
        _subjectId = subjectId;
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
        [objc_getClass("SVProgressHUD") showWithStatus:@"精品课文章列表下载中"];
    });
    
    DDDataService *dataService = [objc_getClass("DDDataService") sharedClient];
    [dataService DD_DDLiveGetCourseDetailById:self.subjectId callBack:^(long long page, NSDictionary *data, BOOL success) {
        if (![data isKindOfClass:[NSDictionary class]] || [data count] == 0) {
            [self finish];
            return;
        }
        
        NSArray *lessons = [[data valueForKey:@"c"] valueForKey:@"lessons"];
        if ([lessons count] == 0) {
            [self finish];
            return;
        }
        
        NSArray *audioIds = [lessons valueForKeyPath:@"audio.a_id"];
        if ([audioIds count] == 0) {
            [self finish];
            return;
        }
        
        NSArray *titles = [lessons valueForKey:@"title"];
        if ([titles count] == 0) {
            [self finish];
            return;
        }
        
        self.audioIds = audioIds;
        self.titles = titles;
        
        [self finish];
    }];
}

- (void)cancel {
    [super cancel];
    [self finish];
}


@end
