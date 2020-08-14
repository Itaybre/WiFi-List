#import "IBRootViewController.h"
#import "IBWiFiManager.h"
#import "MobileWiFi.h"
#import "IBWiFiNetwork.h"

@interface IBRootViewController ()
@end

@implementation IBRootViewController

- (void)loadView {
	[super loadView];

	self.title = @"WiFi List";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Sort"] style:UIBarButtonItemStylePlain target:self action:@selector(sortTapped:)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareTapped:)];
}

- (void)shareTapped:(id)sender {
	NSLog(@"WiFiList - Share Tapped");
}

- (void) sortTapped:(id)sender {
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

	IBWiFiNetwork *network = [IBWiFiManager sharedManager].networks[indexPath.row];
	cell.textLabel.text = network.name;
	cell.detailTextLabel.text = network.password;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
