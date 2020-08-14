#import "IBWiFiManager.h"
#import "MobileWiFi.h"
#import "IBWiFiNetwork.h"

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
        NSArray *filteredNetworks = [self filterOpenNetworks:allNetworks]; 
        self.networks = [self mapNetworks:filteredNetworks];
    }
}

- (NSArray *) filterOpenNetworks:(NSArray *) networks {
    return [networks filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id network, NSDictionary *bindings) {
        return (__bridge NSString *) WiFiNetworkCopyPassword((__bridge WiFiNetworkRef)network) != NULL;
    }]];
}

- (NSArray *) mapNetworks:(NSArray *) networks {
    NSMutableArray *array = [NSMutableArray new];

    for(id network in networks) {
        [array addObject:[[IBWiFiNetwork alloc] initWithNetwork:(__bridge WiFiNetworkRef)network]];
    }

    return array;
}

@end