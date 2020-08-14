#import <Foundation/Foundation.h>

@interface IBWiFiManager : NSObject

@property (nonatomic, retain) NSArray *networks;

+ (instancetype) sharedManager;
@end