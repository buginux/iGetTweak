//
//  FetchLessonContentOperation.h
//  DeDaoTweak
//
//  Created by buginux on 2018/4/27.
//

#import "AsyncOperation.h"

/** 精品课内容详情 */
@interface FetchLessonContentOperation : AsyncOperation

- (instancetype)initWithAudioId:(NSString *)audioId title:(NSString *)title;

@end
