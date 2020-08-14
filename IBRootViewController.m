#import "IBRootViewController.h"
#import "IBWiFiManager.h"
#import "MobileWiFi.h"
#import "IBWiFiNetwork.h"
#import "IBDetailViewController.h"

@interface IBRootViewController () <UISearchResultsUpdating>
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation IBRootViewController

- (void)loadView {
	[super loadView];

	self.title = @"WiFi List";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Sort"] style:UIBarButtonItemStylePlain target:self action:@selector(sortTapped:)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareTapped:)];

	self.searchController = [[UISearchController alloc] init];
	self.searchController.searchResultsUpdater = self;
	self.searchController.obscuresBackgroundDuringPresentation = NO;
	self.searchController.searchBar.placeholder = @"Search Networks";
	self.navigationItem.searchController = self.searchController;
	self.definesPresentationContext = YES;
}

- (void)shareTapped:(id)sender {
	NSLog(@"WiFiList - Share Tapped");
}

- (void) sortTapped:(id)sender {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sort Order" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction *nameActionAsc = [UIAlertAction actionWithTitle:@"Name Ascending" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
		[self setSortOrder:NAME_ASC];
	}];
	UIAlertAction *nameActionDesc = [UIAlertAction actionWithTitle:@"Name Descending" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
		[self setSortOrder:NAME_DESC];
	}];
	UIAlertAction *addedActionAsc = [UIAlertAction actionWithTitle:@"Added Ascending" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
		[self setSortOrder:ADDED_ASC];
	}];
	UIAlertAction *addedActionDesc = [UIAlertAction actionWithTitle:@"Added Descending" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
		[self setSortOrder:ADDED_DESC];
	}];
	UIAlertAction *joinedActionAsc = [UIAlertAction actionWithTitle:@"Last Joined Ascending" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
		[self setSortOrder:LAST_JOINED_ASC];
	}];
	UIAlertAction *joinedActionDesc = [UIAlertAction actionWithTitle:@"Last Joined Descending" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
		[self setSortOrder:LAST_JOINED_DESC];
	}];
	[alert addAction:nameActionAsc];
	[alert addAction:nameActionDesc];
	[alert addAction:addedActionAsc];
	[alert addAction:addedActionDesc];
	[alert addAction:joinedActionAsc];
	[alert addAction:joinedActionDesc];
	[self presentViewController:alert animated:YES completion:nil];
}

- (void) setSortOrder:(SortCriteria) newCriteria {
	if ([IBWiFiManager sharedManager].sortCriteria == newCriteria) {
		return;
	}
	[IBWiFiManager sharedManager].sortCriteria = newCriteria;
	[[IBWiFiManager sharedManager] refreshNetworks];
	[self.tableView reloadData];
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
	IBWiFiNetwork *network = [IBWiFiManager sharedManager].networks[indexPath.row];
	IBDetailViewController *detail = [[IBDetailViewController alloc] initWithNetwork:network];
    [self.navigationController pushViewController:detail animated:true];
}

#pragma mark - UISearch

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	UISearchBar *searchBar = searchController.searchBar;
	NSString *text = searchBar.text;
	[[IBWiFiManager sharedManager] setFilter:text];
	[self.tableView reloadData];
}

@end
