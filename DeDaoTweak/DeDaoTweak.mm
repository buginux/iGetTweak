#line 1 "/Users/justwe/iOSReverse/DeDao/DeDaoTweak/DeDaoTweak/DeDaoTweak.xm"


#import "DeDao.h"
#import "FetchArticleListOperation.h"
#import "FetchArticleContentOperation.h"
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

@class SubscribeSettingsViewControllerV2; 
static void (*_logos_orig$_ungrouped$SubscribeSettingsViewControllerV2$initDatas)(_LOGOS_SELF_TYPE_NORMAL SubscribeSettingsViewControllerV2* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SubscribeSettingsViewControllerV2$initDatas(_LOGOS_SELF_TYPE_NORMAL SubscribeSettingsViewControllerV2* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SubscribeSettingsViewControllerV2$tableView$didSelectRowAtIndexPath$)(_LOGOS_SELF_TYPE_NORMAL SubscribeSettingsViewControllerV2* _LOGOS_SELF_CONST, SEL, UITableView *, NSIndexPath *); static void _logos_method$_ungrouped$SubscribeSettingsViewControllerV2$tableView$didSelectRowAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL SubscribeSettingsViewControllerV2* _LOGOS_SELF_CONST, SEL, UITableView *, NSIndexPath *); 

#line 8 "/Users/justwe/iOSReverse/DeDao/DeDaoTweak/DeDaoTweak/DeDaoTweak.xm"


static void _logos_method$_ungrouped$SubscribeSettingsViewControllerV2$initDatas(_LOGOS_SELF_TYPE_NORMAL SubscribeSettingsViewControllerV2* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	_logos_orig$_ungrouped$SubscribeSettingsViewControllerV2$initDatas(self, _cmd);

	[self.dataArray addObject:@"下载文章"];
	[self.iconImageArray addObject:@"subscribe_notify_icon"];
}

static void _logos_method$_ungrouped$SubscribeSettingsViewControllerV2$tableView$didSelectRowAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL SubscribeSettingsViewControllerV2* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UITableView * tableView, NSIndexPath * indexPath) {
	_logos_orig$_ungrouped$SubscribeSettingsViewControllerV2$tableView$didSelectRowAtIndexPath$(self, _cmd, tableView, indexPath);

	NSString *title = self.dataArray[indexPath.section];
	if ([title isEqualToString:@"下载文章"]) {

		dispatch_queue_t downloadQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);

		dispatch_async(downloadQueue, ^{
			FetchArticleListOperation *operation = [[FetchArticleListOperation alloc] initWithSubscribeId:self.detailData.subscribe_id page:1];
			[[DownloadQueueManager sharedManager] addOperation:operation];
			[[DownloadQueueManager sharedManager] waitUntilAllOperationsAreFinished];

			if ([operation.articleIds count] == 0) {
				return;
			}

			NSInteger articleId = [operation.articleIds.firstObject integerValue];
			FetchArticleContentOperation *articleOperation = [[FetchArticleContentOperation alloc] initWithArticleId:articleId index:1];
			[[DownloadQueueManager sharedManager] addOperation:articleOperation];
		});


	}
}

			
			
   
   
			


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SubscribeSettingsViewControllerV2 = objc_getClass("SubscribeSettingsViewControllerV2"); MSHookMessageEx(_logos_class$_ungrouped$SubscribeSettingsViewControllerV2, @selector(initDatas), (IMP)&_logos_method$_ungrouped$SubscribeSettingsViewControllerV2$initDatas, (IMP*)&_logos_orig$_ungrouped$SubscribeSettingsViewControllerV2$initDatas);MSHookMessageEx(_logos_class$_ungrouped$SubscribeSettingsViewControllerV2, @selector(tableView:didSelectRowAtIndexPath:), (IMP)&_logos_method$_ungrouped$SubscribeSettingsViewControllerV2$tableView$didSelectRowAtIndexPath$, (IMP*)&_logos_orig$_ungrouped$SubscribeSettingsViewControllerV2$tableView$didSelectRowAtIndexPath$);} }
#line 50 "/Users/justwe/iOSReverse/DeDao/DeDaoTweak/DeDaoTweak/DeDaoTweak.xm"
