#import "IBRootViewController.h"
#import "IBWiFiManager.h"
#import "MobileWiFi.h"
#import "IBWiFiNetwork.h"
#import "IBDetailViewController.h"
#import "IBTableViewCell.h"
#import <MessageUI/MessageUI.h>

@interface IBRootViewController () <UISearchResultsUpdating, MFMailComposeViewControllerDelegate, IBTableViewCellDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation IBRootViewController

- (void)viewDidLoad {
	[super viewDidLoad];


	UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"Copy Password" action:@selector(copyPassword:)];
	UIMenuItem *deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"Forget Network" action:@selector(deleteNetwork:)];
	[[UIMenuController sharedMenuController] setMenuItems: @[copyMenuItem, deleteMenuItem]];
	[[UIMenuController sharedMenuController] update];
}

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
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
		mailVC.mailComposeDelegate = self; 

		[mailVC setSubject:[NSString stringWithFormat:@"WiFi List from %@", [[UIDevice currentDevice] name]]];

		NSMutableString *mailContent = [NSMutableString string];
		for(IBWiFiNetwork *network in [IBWiFiManager sharedManager].networks) {
			[mailContent appendFormat:@"<b>%@</b><br />%@<br /><br />", network.name, network.password];
		}

		[mailVC setMessageBody:mailContent isHTML:YES];
		[self presentViewController:mailVC animated:YES completion:nil];
	}
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
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

	[alert addAction:nameActionAsc];
	[alert addAction:nameActionDesc];
	[alert addAction:addedActionAsc];
	[alert addAction:addedActionDesc];
	[alert addAction:joinedActionAsc];
	[alert addAction:joinedActionDesc];
	[alert addAction:cancelAction];

	[[alert popoverPresentationController] setSourceView:self.view];
	[[alert popoverPresentationController] setSourceRect:CGRectMake(0,0,1,1)];
	[[alert popoverPresentationController] setPermittedArrowDirections:UIPopoverArrowDirectionUp];


	[self presentViewController:alert animated:YES completion:nil];
}

- (void) setSortOrder:(SortCriteria) newCriteria {
	if ([IBWiFiManager sharedManager].sortCriteria == newCriteria) {
		return;
	}
	[IBWiFiManager sharedManager].sortCriteria = newCriteria;
	[[IBWiFiManager sharedManager] refreshNetworks];
	[self.tableView reloadData];
	[[NSUserDefaults standardUserDefaults] setInteger:newCriteria forKey:@"sortOrder"];
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
	IBTableViewCell *cell = (IBTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (!cell) {
		cell = [[IBTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.delegate = self;
	}

	IBWiFiNetwork *network = [IBWiFiManager sharedManager].networks[indexPath.row];
	[cell setUpForNetwork:network];
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(copyPassword:) || action == @selector(deleteNetwork:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
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

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error 
{    
    [self dismissViewControllerAnimated:YES completion:nil]; 
}

#pragma mark - IBTableViewCellDelegate

- (void) refreshTable {
	[self.tableView reloadData];
}

@end
