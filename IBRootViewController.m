#import "IBRootViewController.h"
#import "IBWiFiManager.h"
#import "MobileWiFi.h"


@interface IBRootViewController ()
@end

@implementation IBRootViewController

- (void)loadView {
	[super loadView];

	self.title = @"WiFi List";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareTapped:)];
}

- (void)shareTapped:(id)sender {
	NSLog(@"WiFiList - Share Tapped");
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [IBWiFiManager sharedManager].networks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}

	WiFiNetworkRef network = (__bridge WiFiNetworkRef) [IBWiFiManager sharedManager].networks[indexPath.row];
	cell.textLabel.text = (__bridge NSString *) WiFiNetworkGetSSID(network);
	cell.detailTextLabel.text = (__bridge NSString *) WiFiNetworkCopyPassword(network);
	return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
