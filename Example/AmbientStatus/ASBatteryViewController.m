//
//  ASBatteryViewController.m
//  AmbientStatus
//
//  Created by Rudd Fawcett on 6/26/14.
//  Copyright (c) 2014 rexfinn. All rights reserved.
//

#import "ASBatteryViewController.h"

@interface ASBatteryViewController ()

@property (strong, nonatomic) ASBatteryMonitor *batteryMonitor;

@end

@implementation ASBatteryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"ASBatteryMonitor";
    
    self.batteryMonitor = [ASBatteryMonitor sharedInstance];
    self.batteryMonitor.delegate = self;
    
    [self.batteryMonitor startMonitoring];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0 || section == 1) {
        return 1;
    }
    else return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return @"Battery States";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSArray *batteryStates = @[@(UIDeviceBatteryStateUnknown), @(UIDeviceBatteryStateCharging), @(UIDeviceBatteryStateUnplugged), @(UIDeviceBatteryStateFull)];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        cell.textLabel.text = @"Monitoring Battery";
        
        UISwitch *batteryMonitoring = [UISwitch new];
        batteryMonitoring.on = self.batteryMonitor.isMonitoring;
        
        [batteryMonitoring addTarget:self action:@selector(toggleBatteryMonitoring) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = batteryMonitoring;
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = @"Battery Level";
        
        if (!self.batteryMonitor.isMonitoring) {
            cell.detailTextLabel.text = @"Unknown";
        }
        else {
            cell.detailTextLabel.text = [NSString floatToPercentString:self.batteryMonitor.percentage];
        }
    }
    else if (indexPath.section == 2) {
        UIDeviceBatteryState state = [[batteryStates objectAtIndex:indexPath.row] integerValue];
        
        cell.textLabel.text = [NSString batteryStateToString:state];
        
        if (self.batteryMonitor.state == state) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

- (IBAction)toggleBatteryMonitoring {
    [self.batteryMonitor toggleMonitoring];
}

#pragma mark - ASBatteryMonitorDelegate Methods

- (void)batteryMonitor:(ASBatteryMonitor *)batteryMonitor didChangeBatteryState:(UIDeviceBatteryState)state {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)batteryMonitor:(ASBatteryMonitor *)batteryMonitor didChangeBatteryLevel:(CGFloat)level {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
