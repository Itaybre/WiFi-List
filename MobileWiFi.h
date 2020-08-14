#import <Foundation/Foundation.h>

typedef struct __WiFiNetwork* WiFiNetworkRef;
typedef struct __WiFiManager* WiFiManagerRef;

extern WiFiManagerRef   WiFiManagerClientCreate(CFAllocatorRef allocator, int flags);
extern CFArrayRef       WiFiManagerClientCopyNetworks(WiFiManagerRef manager);
extern CFStringRef      WiFiNetworkGetSSID(WiFiNetworkRef network);
extern Boolean          WiFiNetworkIsWEP(WiFiNetworkRef network);
extern Boolean          WiFiNetworkIsWPA(WiFiNetworkRef network);
extern Boolean          WiFiNetworkIsEAP(WiFiNetworkRef network);
extern CFStringRef      WiFiNetworkCopyPassword(WiFiNetworkRef network);