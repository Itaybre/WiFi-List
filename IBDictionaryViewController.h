#import <UIKit/UIKit.h>

@interface IBDictionaryViewController : UITableViewController
@property (nonatomic,strong) NSDictionary *dictionary;
- (id)initWithDictionary:(NSDictionary*)dictionary;
@end