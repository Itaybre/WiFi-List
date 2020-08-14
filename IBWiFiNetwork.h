#import <Foundation/Foundation.h>
#import "MobileWiFi.h"

@interface IBWiFiNetwork: NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, retain) NSDictionary *records;

- (instancetype) initWithNetwork:(WiFiNetworkRef) network;
@end