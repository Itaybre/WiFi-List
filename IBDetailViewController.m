#import "IBDetailViewController.h"

@implementation IBDetailViewController

- (id)initWithDictionary:(NSDictionary*)dict {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        HBLogDebug(@"WiFiList - %@", dict);
        self.records = dict;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.allKeys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [self.records.allKeys objectAtIndex:indexPath.row];
    
    NSString *formatted = [NSString stringWithFormat:@"%@", [self.records valueForKey:[self.records.allKeys objectAtIndex:indexPath.row]]];
    NSString *detail = [[formatted componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    cell.detailTextLabel.text = detail;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *object = [self.records valueForKey:[self.records.allKeys objectAtIndex:indexPath.row]];
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        IBDetailViewController *vc = [[IBDetailViewController alloc] initWithDictionary:(NSDictionary*)object];
        [self.navigationController pushViewController:vc animated:true];
    }
    
}

@end