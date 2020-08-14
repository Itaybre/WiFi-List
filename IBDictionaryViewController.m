#import "IBDictionaryViewController.h"

@implementation IBDictionaryViewController

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super initWithStyle:UITableViewStyleInsetGrouped]) {
        self.dictionary = dictionary;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dictionary.allKeys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [self.dictionary.allKeys objectAtIndex:indexPath.row];
    
    NSString *formatted = [NSString stringWithFormat:@"%@", [self.dictionary valueForKey:[self.dictionary.allKeys objectAtIndex:indexPath.row]]];
    NSString *detail = [[formatted componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    cell.detailTextLabel.text = detail;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *object = [self.dictionary valueForKey:[self.dictionary.allKeys objectAtIndex:indexPath.row]];
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        IBDictionaryViewController *viewController = [[IBDictionaryViewController alloc] initWithDictionary:(NSDictionary*)object];
        [self.navigationController pushViewController:viewController animated:true];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [[UIPasteboard generalPasteboard] setString:cell.detailTextLabel.text];
    }
}

@end