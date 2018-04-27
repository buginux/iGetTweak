//
//  DeoDao.h
//  DeDaoTweak
//
//  Created by 杨志超 on 2017/9/19.
//
//

#import <UIKit/UIKit.h>



@interface DataServiceV2 : NSObject

+ (id)GetInstance;
- (void)FM_GetColumnArticlesByColumnId:(id)arg1 page:(id)arg2 pageSize:(id)arg3 order:(id)arg4 callBack:(void (^)(long long, NSDictionary *, BOOL))arg5;
- (void)FM_GetArticleContentById:(long long)arg1 callBack:(void (^)(long long, NSDictionary *, BOOL))arg2;

@end

@interface DDDataService : NSObject

+ (id)sharedClient;
- (void)DD_DDLiveGetCourseDetailById:(id)arg1 callBack:(void (^)(long long, NSDictionary *, BOOL))arg2;

@end

@interface DDBaseRequest : NSObject

@property(readonly, nonatomic) NSHTTPURLResponse *response;
@property(retain, nonatomic) NSData *responseData; // @synthesize responseData=_responseData;
@property(readonly, nonatomic) NSDictionary *responseHeaders;
@property(retain, nonatomic) id responseJSONObject; // @synthesize responseJSONObject=_responseJSONObject;
@property(retain, nonatomic) id responseObject; // @synthesize responseObject=_responseObject;

@end

@interface DDFreeColumnArticleApi : NSObject

@property(copy, nonatomic) NSString *audioIndentify; // @synthesize audioIndentify=_audioIndentify;
- (void)startWithCompletionBlockWithSuccess:(void (^)(DDBaseRequest *))arg1 failure:(void (^)(DDBaseRequest *))arg2;

@end

@interface FMSubscribeDetailEntity : NSObject

@property(retain, nonatomic) NSNumber *subscribe_id; // @synthesize subscribe_id=_subscribe_id;
@property(retain, nonatomic) NSString *subscribe_title; // @synthesize subscribe_title=_subscribe_title;

@end

@interface SubscribeSettingsViewControllerV2 : UIViewController

@property(retain, nonatomic) NSMutableArray *dataArray; // @synthesize dataArray=_dataArray;
@property(retain, nonatomic) FMSubscribeDetailEntity *detailData; // @synthesize detailData=_detailData;
@property(retain, nonatomic) NSMutableArray *iconImageArray; // @synthesize iconImageArray=_iconImageArray;

@end

@interface DDLiveSubjectViewController : UIViewController

@property(copy, nonatomic) NSString *subjectId; // @synthesize subjectId=_subjectId;

@end

@interface SubscribeInfoViewModelV2 : NSObject

- (id)getArticleAESKey:(long long)arg1 articleSecret:(id)arg2;

@end

@interface NSData (AES)

- (id)AES128Decrypt:(id)arg1;
- (id)AES128DecryptWithKey:(id)arg1;
- (id)AES128EncryptWithKey:(id)arg1;

@end
