#import "IBWiFiManager.h"
#import "MobileWiFi.h"

@implementation IBWiFiManager

+ (instancetype) sharedManager {
	static IBWiFiManager *sharedWiFiManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWiFiManager = [[self alloc] init];
    });
    return sharedWiFiManager;
}

- (instancetype) init {
    if(self = [super init]) {
        [self loadNetworks];
    }
    return self;
}

- (void) loadNetworks {
    WiFiManagerRef manager = WiFiManagerClientCreate(kCFAllocatorDefault, 0);
    if (manager) {
        NSArray *allNetworks = (__bridge NSArray *) WiFiManagerClientCopyNetworks(manager);
        self.networks = [self filterOpenNetworks:allNetworks]; 
    }
}

- (NSArray *) filterOpenNetworks:(NSArray *) networks {
    return [networks filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id network, NSDictionary *bindings) {
        return (__bridge NSString *) WiFiNetworkCopyPassword((__bridge WiFiNetworkRef)network) != NULL;
    }]];
}

@end