#line 1 "/Users/buginux/Github/iGetTweak/DeDaoTweak/DeDaoTweak.xm"


#import "DeDao.h"
#import "FetchArticleListOperation.h"
#import "FetchArticleContentOperation.h"
#import "FetchLessonListOperation.h"
#import "FetchLessonContentOperation.h"
#import "DownloadQueueManager.h"


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SubscribeSettingsViewControllerV2; @class DDLiveSubjectViewController; @class SVProgressHUD; 
static void (*_logos_orig$_ungrouped$SubscribeSettingsViewControllerV2$initDatas)(_LOGOS_SELF_TYPE_NORMAL SubscribeSettingsViewControllerV2* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SubscribeSettingsViewControllerV2$initDatas(_LOGOS_SELF_TYPE_NORMAL SubscribeSettingsViewControllerV2* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SubscribeSettingsViewControllerV2$tableView$didSelectRowAtIndexPath$)(_LOGOS_SELF_TYPE_NORMAL SubscribeSettingsViewControllerV2* _LOGOS_SELF_CONST, SEL, UITableView *, NSIndexPath *); static void _logos_method$_ungrouped$SubscribeSettingsViewControllerV2$tableView$didSelectRowAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL SubscribeSettingsViewControllerV2* _LOGOS_SELF_CONST, SEL, UITableView *, NSIndexPath *); static void (*_logos_orig$_ungrouped$DDLiveSubjectViewController$shareBtnClick$)(_LOGOS_SELF_TYPE_NORMAL DDLiveSubjectViewController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$DDLiveSubjectViewController$shareBtnClick$(_LOGOS_SELF_TYPE_NORMAL DDLiveSubjectViewController* _LOGOS_SELF_CONST, SEL, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SVProgressHUD(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SVProgressHUD"); } return _klass; }
#line 10 "/Users/buginux/Github/iGetTweak/DeDaoTweak/DeDaoTweak.xm"


static void _logos_method$_ungrouped$SubscribeSettingsViewControllerV2$initDatas(_LOGOS_SELF_TYPE_NORMAL SubscribeSettingsViewControllerV2* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	_logos_orig$_ungrouped$SubscribeSettingsViewControllerV2$initDatas(self, _cmd);

	[self.dataArray addObject:@"下载文章"];
	[self.iconImageArray addObject:@"subscribe_notify_icon"];
}

static void _logos_method$_ungrouped$SubscribeSettingsViewControllerV2$tableView$didSelectRowAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL SubscribeSettingsViewControllerV2* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UITableView * tableView, NSIndexPath * indexPath) {
	_logos_orig$_ungrouped$SubscribeSettingsViewControllerV2$tableView$didSelectRowAtIndexPath$(self, _cmd, tableView, indexPath);

	NSString *title = self.dataArray[indexPath.section];
	if ([title isEqualToString:@"下载文章"]) {

		NSInteger pageSize = 20;

		dispatch_queue_t downloadQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);

		dispatch_async(downloadQueue, ^{
			NSInteger currentPage = 0;
			NSArray *articleIds = nil;
			do {
				FetchArticleListOperation *operation = [[FetchArticleListOperation alloc] initWithSubscribeId:self.detailData.subscribe_id page:currentPage pageSize:pageSize];
				[[DownloadQueueManager sharedManager] addOperation:operation];
				[[DownloadQueueManager sharedManager] waitUntilAllOperationsAreFinished];

				articleIds = operation.articleIds;
				for(NSInteger i = 0; i < articleIds.count; i++) {
					NSInteger articleId = [articleIds[i] integerValue];
					FetchArticleContentOperation *articleOperation = [[FetchArticleContentOperation alloc] initWithArticleId:articleId page:currentPage index:i];
					articleOperation.subscribeTitle = self.detailData.subscribe_title;
					[[DownloadQueueManager sharedManager] addOperation:articleOperation];
				}
				[[DownloadQueueManager sharedManager] waitUntilAllOperationsAreFinished];

				++currentPage;
			} while (articleIds.count == pageSize);

			dispatch_async(dispatch_get_main_queue(), ^{
				[_logos_static_class_lookup$SVProgressHUD() dismiss];
				NSString *message = [NSString stringWithFormat:@"下载完成，共 %ld 页，每页 %ld 篇", currentPage, pageSize];
       			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
       			[alert show];
			});
		});
	}
}

			
			
   
   
			





static void _logos_method$_ungrouped$DDLiveSubjectViewController$shareBtnClick$(_LOGOS_SELF_TYPE_NORMAL DDLiveSubjectViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
	dispatch_queue_t downloadQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);

	dispatch_async(downloadQueue, ^{
		
		FetchLessonListOperation *operation = [[FetchLessonListOperation alloc] initWithSubjectId:self.subjectId];
		[[DownloadQueueManager sharedManager] addOperation:operation];
		[[DownloadQueueManager sharedManager] waitUntilAllOperationsAreFinished];

		NSArray *audioIds = operation.audioIds;
		NSArray *titles = operation.titles;

		for(NSInteger i = 0; i < audioIds.count; i++) {
			NSString *title = titles[i];
			FetchLessonContentOperation *contentOperation = [[FetchLessonContentOperation alloc] initWithAudioId:audioIds[i] title:title];
			[[DownloadQueueManager sharedManager] addOperation:contentOperation];
		}
		[[DownloadQueueManager sharedManager] waitUntilAllOperationsAreFinished];

		dispatch_async(dispatch_get_main_queue(), ^{
			[_logos_static_class_lookup$SVProgressHUD() dismiss];
			NSString *message = [NSString stringWithFormat:@"下载完成，共 %ld 篇", (long)[audioIds count]];
       		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
       		[alert show];
		});
	});
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SubscribeSettingsViewControllerV2 = objc_getClass("SubscribeSettingsViewControllerV2"); MSHookMessageEx(_logos_class$_ungrouped$SubscribeSettingsViewControllerV2, @selector(initDatas), (IMP)&_logos_method$_ungrouped$SubscribeSettingsViewControllerV2$initDatas, (IMP*)&_logos_orig$_ungrouped$SubscribeSettingsViewControllerV2$initDatas);MSHookMessageEx(_logos_class$_ungrouped$SubscribeSettingsViewControllerV2, @selector(tableView:didSelectRowAtIndexPath:), (IMP)&_logos_method$_ungrouped$SubscribeSettingsViewControllerV2$tableView$didSelectRowAtIndexPath$, (IMP*)&_logos_orig$_ungrouped$SubscribeSettingsViewControllerV2$tableView$didSelectRowAtIndexPath$);Class _logos_class$_ungrouped$DDLiveSubjectViewController = objc_getClass("DDLiveSubjectViewController"); MSHookMessageEx(_logos_class$_ungrouped$DDLiveSubjectViewController, @selector(shareBtnClick:), (IMP)&_logos_method$_ungrouped$DDLiveSubjectViewController$shareBtnClick$, (IMP*)&_logos_orig$_ungrouped$DDLiveSubjectViewController$shareBtnClick$);} }
#line 98 "/Users/buginux/Github/iGetTweak/DeDaoTweak/DeDaoTweak.xm"
