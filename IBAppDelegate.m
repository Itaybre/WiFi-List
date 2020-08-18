#import "IBAppDelegate.h"
#import "IBRootViewController.h"

@implementation IBAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	UITableViewStyle style = UITableViewStylePlain;
	if (@available(iOS 13, *)) {
		style = UITableViewStyleInsetGrouped;
	}
	_rootViewController = [[UINavigationController alloc] initWithRootViewController:[[IBRootViewController alloc] initWithStyle:style]];
	_window.rootViewController = _rootViewController;
	[_window makeKeyAndVisible];
}

@end
