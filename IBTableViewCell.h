#import <UIKit/UIKit.h>

@class IBWiFiNetwork;

@protocol IBTableViewCellDelegate
- (void) refreshTable;
@end

@interface IBTableViewCell: UITableViewCell
@property (nonatomic, strong) IBWiFiNetwork *network;
@property (nonatomic, weak) id<IBTableViewCellDelegate> delegate;
- (void) setUpForNetwork:(IBWiFiNetwork *) network;
@end