#import "IBWiFiNetwork.h"

@implementation IBWiFiNetwork

- (instancetype) initWithNetwork:(WiFiNetworkRef) network {
    if(self = [super init]) {
        self.name = (__bridge NSString *) WiFiNetworkGetSSID(network);
        self.password = (__bridge NSString *) WiFiNetworkCopyPassword(network);
        self.records = (__bridge NSDictionary *) WiFiNetworkCopyRecord(network);
    }
    return self;
}

@end