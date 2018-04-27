// See http://iphonedevwiki.net/index.php/Logos

#import "DeDao.h"
#import "FetchArticleListOperation.h"
#import "FetchArticleContentOperation.h"
#import "FetchLessonListOperation.h"
#import "FetchLessonContentOperation.h"
#import "DownloadQueueManager.h"

%hook SubscribeSettingsViewControllerV2

- (void)initDatas {
	%orig;

	[self.dataArray addObject:@"下载文章"];
	[self.iconImageArray addObject:@"subscribe_notify_icon"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	%orig;

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
				[%c(SVProgressHUD) dismiss];
				NSString *message = [NSString stringWithFormat:@"下载完成，共 %ld 页，每页 %ld 篇", currentPage, pageSize];
       			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
       			[alert show];
			});
		});
	}
}

			// dispatch_async(dispatch_get_main_queue(), ^{
			//        NSString *message = [NSString stringWithFormat:@"%@", articleOperation];
   //     	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
   //     [alert show];
			// });

%end

%hook DDLiveSubjectViewController

- (void)shareBtnClick:(id)arg1 {
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
			[%c(SVProgressHUD) dismiss];
			NSString *message = [NSString stringWithFormat:@"下载完成，共 %ld 篇", (long)[audioIds count]];
       		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
       		[alert show];
		});
	});
}

%end
