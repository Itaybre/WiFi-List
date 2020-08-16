#import "IBTableViewCell.h"
#import "IBWiFiNetwork.h"
#import "IBWiFiManager.h"

@implementation IBTableViewCell

- (void) setUpForNetwork:(IBWiFiNetwork *) network {
	self.textLabel.text = network.name;
	self.detailTextLabel.text = network.password;
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	self.network = network;
}

-(BOOL) canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copyPassword:) || action == @selector(deleteNetwork:));
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void) copyPassword:(id) sender {
    [[UIPasteboard generalPasteboard] setString:self.network.password];
}

-(void) deleteNetwork:(id) sender {
    [[IBWiFiManager sharedManager] forgetNetwork:self.network];
    [self.delegate refreshTable];
}
@end