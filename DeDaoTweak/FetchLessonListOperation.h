//
//  FetchLessonListOperation.h
//  DeDaoTweak
//
//  Created by buginux on 2018/4/27.
//

#import "AsyncOperation.h"

/** 精品课文章列表 */
@interface FetchLessonListOperation : AsyncOperation

@property (nonatomic, strong) NSArray *audioIds;
@property (nonatomic, strong) NSArray *titles;

- (instancetype)initWithSubjectId:(NSString *)subjectId;

@end
