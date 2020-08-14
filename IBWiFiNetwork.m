#import "IBWiFiNetwork.h"

@implementation IBWiFiNetwork

- (instancetype) initWithNetwork:(WiFiNetworkRef) network {
    if(self = [super init]) {
        self.name = (__bridge NSString *) WiFiNetworkGetSSID(network);
        self.password = (__bridge NSString *) WiFiNetworkCopyPassword(network);
        self.allRecords = (__bridge NSDictionary *) WiFiNetworkCopyRecord(network);

        self.channel = [[self.allRecords objectForKey:@"CHANNEL"] integerValue];
        self.added = [self.allRecords objectForKey:@"addedAt"];
        self.lastManualJoin = [self.allRecords objectForKey:@"lastJoined"];
        self.lastAutoJoin = [self.allRecords objectForKey:@"lastAutoJoined"];

        if (WiFiNetworkIsWEP(network)) {
            self.encryption = WEP;
        } else if (WiFiNetworkIsWPA(network)) {
            self.encryption = WPA;
        } else if (WiFiNetworkIsEAP(network)) {
            self.encryption = EAP;
        } else {
            self.encryption = NONE;
        }
    }
    return self;
}

- (NSDate *) lastJoinDate {
    if ([self.lastManualJoin compare:self.lastAutoJoin] == NSOrderedDescending) {
        return self.lastManualJoin;
    }
    return self.lastAutoJoin;
}

@end