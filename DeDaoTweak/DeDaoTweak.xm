// See http://iphonedevwiki.net/index.php/Logos

#import "DeDao.h"
#import "FetchArticleListOperation.h"
#import "FetchArticleContentOperation.h"
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

			// dispatch_async(dispatch_get_main_queue(), ^{
			//        NSString *message = [NSString stringWithFormat:@"%@", articleOperation];
   //     	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
   //     [alert show];
			// });

%end
