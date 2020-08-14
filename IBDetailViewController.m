#import "IBDetailViewController.h"
#import "IBWiFiNetwork.h"

@interface IBDetailViewController () 
@property (nonatomic, strong) IBWiFiNetwork *network;
@end

@implementation IBDetailViewController

- (id)initWithNetwork:(IBWiFiNetwork *)network; {
    self = [super initWithStyle:UITableViewStyleInsetGrouped];
    if (self) {
        self.network = network;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];

    self.title = self.network.name;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    }

    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Network Info";
    } else if (section == 1) {
        return @"Dates";
    }

    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"SSID";
            cell.detailTextLabel.text = self.network.name;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Password";
            cell.detailTextLabel.text = self.network.password;
        } else {
            cell.textLabel.text = @"Encryption";
            cell.detailTextLabel.text = self.network.encryption == WEP ? @"WEP" : self.network.encryption == WPA ? @"WPA/WPA2" : self.network.encryption == EAP ? @"EAP" : @"None";
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd MMM yyyy HH:mm"];

            cell.textLabel.text = @"Added";
            cell.detailTextLabel.text = [formatter stringFromDate:self.network.added];
        } else if (indexPath.row == 1) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd MMM yyyy HH:mm"];
            
            cell.textLabel.text = @"Last Joined";
            cell.detailTextLabel.text = [formatter stringFromDate:self.network.lastJoined];
        }
    } else {
        cell.textLabel.text = @"View Raw Data";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)){
        [[UIPasteboard generalPasteboard] setString:self.network.password];
    }
}

@end