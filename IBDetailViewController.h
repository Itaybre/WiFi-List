#import <UIKit/UIKit.h>

@interface IBDetailViewController: UITableViewController
@property (nonatomic, strong) NSDictionary *records;
- (id)initWithDictionary:(NSDictionary*)dict;
@end