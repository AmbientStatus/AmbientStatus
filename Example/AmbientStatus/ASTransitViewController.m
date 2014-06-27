//
//  ASBatteryViewController.m
//  AmbientStatus
//
//  Created by Rudd Fawcett on 6/26/14.
//  Copyright (c) 2014 rexfinn. All rights reserved.
//

#import "ASTransitViewController.h"

@interface ASTransitViewController ()

@property (strong, nonatomic) ASTransitMonitor *transitMonitor;

@end

@implementation ASTransitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"ASTransitMonitor";
    
    self.transitMonitor = [ASTransitMonitor sharedInstance];
    self.transitMonitor.delegate = self;
    
    [self.transitMonitor startMonitoring];
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
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 2;
    }
    else return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return @"Transit States";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSArray *transitStates = @[@(ASTransitStateStationary), @(ASTransitStateWalking), @(ASTransitStateRunning), @(ASTransitStateDriving)];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.text = @"Monitoring Transit";
        
        UISwitch *batteryMonitoring = [UISwitch new];
        batteryMonitoring.on = self.transitMonitor.isMonitoring;
        
        [batteryMonitoring addTarget:self action:@selector(toggleTransitMonitoring) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = batteryMonitoring;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Current Speed";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f MPH",[self.transitMonitor currentSpeedAsUnit:ASUnitTypeMilesPerHour]];
        }
        else {
            cell.textLabel.text = @"Device is Shaking";
            
            if (self.transitMonitor.isShaking) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    else if (indexPath.section == 2) {
        ASTransitState state = [[transitStates objectAtIndex:indexPath.row] integerValue];
        
        cell.textLabel.text = [NSString transitStateToString:state];
        
        if (self.transitMonitor.state == state) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

- (IBAction)toggleTransitMonitoring {
    [self.transitMonitor toggleMonitoring];
}

#pragma mark - ASTransitMonitorDelegate Methods

- (void)transitMonitor:(ASTransitMonitor *)transitMonitor didChangeSpeed:(CGFloat)newSpeed oldSpeed:(CGFloat)oldSpeed {
    if (newSpeed - oldSpeed > 0.4f) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)transitMonitor:(ASTransitMonitor *)transitMonitor didAccelerationChange:(CMAcceleration)acceleration {
    BOOL isShaking = transitMonitor.isShaking;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    cell.accessoryType = isShaking ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)transitMonitor:(ASTransitMonitor *)transitMonitor didChangeTransitState:(ASTransitState)transitState {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
