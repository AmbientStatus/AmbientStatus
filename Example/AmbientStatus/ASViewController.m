//
// ASViewController.m
// AmbientStatus
//

#import "ASViewController.h"

@interface ASViewController ()

@property (strong, nonatomic) ASBatteryMonitor *batteryMonitor;

@end

@implementation ASViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"AmbientStatus";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Classes";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSStringFromClass([ASBatteryMonitor class]);
    }
    else {
        cell.textLabel.text = NSStringFromClass([ASTransitMonitor class]);
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id controller;
    
    if (indexPath.row == 0) {
        controller = [[ASBatteryViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    else {
        controller = [[ASTransitViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
