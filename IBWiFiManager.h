#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SortCriteria) {
    NAME_ASC = 0,
    NAME_DESC = 1,
    ADDED_ASC = 2,
    ADDED_DESC = 3,
    LAST_JOINED_ASC = 4,
    LAST_JOINED_DESC = 5
};

@class IBWiFiNetwork;

@interface IBWiFiManager : NSObject

@property (nonatomic, retain) NSArray *networks;
@property (nonatomic) SortCriteria sortCriteria;

+ (instancetype) sharedManager;
- (void) refreshNetworks;
- (void) setFilter:(NSString *)text;
- (void) forgetNetwork:(IBWiFiNetwork *)network;

@end