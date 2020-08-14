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
        self.sortCriteria = NAME_ASC;
        [self loadNetworks];
    }
    return self;
}

- (void) refreshNetworks {
    self.networks = [self sortNetworks:self.networks];
}

- (void) loadNetworks {
    WiFiManagerRef manager = WiFiManagerClientCreate(kCFAllocatorDefault, 0);
    if (manager) {
        NSArray *allNetworks = (__bridge NSArray *) WiFiManagerClientCopyNetworks(manager);
        NSArray *filteredNetworks = [self filterOpenNetworks:allNetworks]; 
        NSArray *mappedNetworks = [self mapNetworks:filteredNetworks];
        self.networks = [self sortNetworks:mappedNetworks];
    }
}

- (NSArray *) sortNetworks: (NSArray *)networks {
    if (self.sortCriteria == NAME_ASC) {
        return [self sortByName:networks ascending:YES];
    } else if (self.sortCriteria == NAME_DESC) {
        return [self sortByName:networks ascending:NO];
    } else if (self.sortCriteria == ADDED_ASC) {
        return [self sortByAdded:networks ascending:YES];
    } else if (self.sortCriteria == ADDED_DESC) {
        return [self sortByAdded:networks ascending:NO];
    } else if (self.sortCriteria == LAST_JOINED_ASC) {
        return [self sortByLastJoined:networks ascending:YES];
    } else if (self.sortCriteria == LAST_JOINED_DESC) {
        return [self sortByLastJoined:networks ascending:NO];
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

- (NSArray *) sortByName:(NSArray *)networks ascending:(BOOL) ascending {
    return [networks sortedArrayUsingComparator: ^(IBWiFiNetwork *network1, IBWiFiNetwork *network2) {
        NSComparisonResult result = [network1.name compare:network2.name options:NSCaseInsensitiveSearch];
        if (ascending) {
            return result;
        } else if (result == NSOrderedAscending) {
            result = NSOrderedDescending;
        } else if (result == NSOrderedDescending) {
            result = NSOrderedAscending;
        }
        return result;
    }];
}

- (NSArray *) sortByAdded:(NSArray *)networks ascending:(BOOL) ascending {
    return [networks sortedArrayUsingComparator: ^(IBWiFiNetwork *network1, IBWiFiNetwork *network2) {
        NSComparisonResult result = [network1.added compare:network2.added];
        if (ascending) {
            return result;
        } else if (result == NSOrderedAscending) {
            result = NSOrderedDescending;
        } else if (result == NSOrderedDescending) {
            result = NSOrderedAscending;
        }
        return result;
    }];
}

- (NSArray *) sortByLastJoined:(NSArray *)networks ascending:(BOOL) ascending {
    return [networks sortedArrayUsingComparator: ^(IBWiFiNetwork *network1, IBWiFiNetwork *network2) {
        NSComparisonResult result = [network1.lastJoined compare:network2.lastJoined];
        if (ascending) {
            return result;
        } else if (result == NSOrderedAscending) {
            result = NSOrderedDescending;
        } else if (result == NSOrderedDescending) {
            result = NSOrderedAscending;
        }
        return result;
    }];
}

@end