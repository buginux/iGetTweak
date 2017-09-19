// See http://iphonedevwiki.net/index.php/Logos

#import "DeDao.h"

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
		[[%c(DataServiceV2) GetInstance] FM_GetColumnArticlesByColumnId:self.detailData.subscribe_id page:@(1) pageSize:@(20) order:@(YES) callBack:^ void (long long page, NSDictionary *data, BOOL success) {
			NSString *msg = [NSString stringWithFormat:@"%ld - %@ - %ld", (long)page, data, (long)success];
			UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"title" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alt show];
		}];
	}
}

%end
