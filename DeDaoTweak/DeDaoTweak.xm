// See http://iphonedevwiki.net/index.php/Logos

#import "DeDao.h"
#import "FetchArticleListOperation.h"

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
		NSOperationQueue *queue = [[NSOperationQueue alloc] init];
		FetchArticleListOperation *operation = [[FetchArticleListOperation alloc] initWithSubscribeId:self.detailData.subscribe_id page:1];
		[queue addOperation:operation];
	}
}

%end
