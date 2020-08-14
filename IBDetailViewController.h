#import <UIKit/UIKit.h>

@class IBWiFiNetwork;

@interface IBDetailViewController: UITableViewController
- (id)initWithNetwork:(IBWiFiNetwork *)network;
@end