//
// ASBatteryMonitor.h
// AmbientStatus
//
// Copyright (c) 2014 Rudd Fawcett <rudd.fawcett@gmail.com> (http://ruddfawcett.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

@class ASBatteryMonitor;

@protocol ASBatteryMonitorDelegate <NSObject>


@optional

/**
 *  Detects if the battery state has changed for the current device ([UIDevice currentDevice]).
 *
 *  @param batteryMonitor An ASBatteryMonitor object.
 *  @param state          The state of the battery: Unknown, Unplugged, Charging, Full.
 */
- (void)batteryMonitor:(ASBatteryMonitor *)batteryMonitor didChangeBatteryState:(UIDeviceBatteryState)state;

/**
 *  Detects if the battery level (percentage) has changed for the current device.
 *
 *  @param batteryMonitor An ASBatteryMonitor object.
 *  @param level          The percentage of the battery level in raw form.  Ex. 0.3
 */
- (void)batteryMonitor:(ASBatteryMonitor *)batteryMonitor didChangeBatteryLevel:(CGFloat)level;

@end

@interface ASBatteryMonitor : NSObject

#pragma mark - Properties

/**
 *  The following readonly properties add getters to an ASBatteryMonitor object:
 *
 *  @property full
 *  @property charging
 *  @property unplugged
 *  @property unknown
 *  @property monitoring
 *
 *  They allow you to check for a specific state of the battery.
 */
@property (readonly, nonatomic, getter=isFull)         BOOL                         full;
@property (readonly, nonatomic, getter=isCharging)     BOOL                         charging;
@property (readonly, nonatomic, getter=isUnplugged)    BOOL                         unplugged;
@property (readonly, nonatomic, getter=isUnknown)      BOOL                         unknown;

/**
 *  @property monitoring Tells you if ASBatteryMonitor is currently listening for changes in battery
 *                       state and level.
 */
@property (readonly, nonatomic, getter=isMonitoring)   BOOL                         monitoring;

/**
 *  @property state The state of the battery in raw UIDeviceBatteryState form.
 */
@property (readonly, nonatomic)                        UIDeviceBatteryState         state;

/**
 *  @property percentage The percentage of the battery as a CGFloat.  0.3 (CGFloat - what you get) not 30% (NSString).
 */
@property (readonly, nonatomic)                        CGFloat                      percentage;

/**
 *  @property delegate The delegate which allows you to run your own methods upon battery state being changed.
 */
@property (nonatomic, weak)                            id<ASBatteryMonitorDelegate> delegate;

#pragma mark - Monitoring Methods

/**
 *  Starts the monitoring of the battery.
 */
- (void)startMonitoring;

/**
 *  Stops the monitoring of the battery.
 */
- (void)stopMonitoring;

/**
 *  Toggles the monitoring of the battery.
 */
- (void)toggleMonitoring;

#pragma mark - Singleton

/**
 *  ASBatteryMonitor singleton.
 *
 *  @return ASBatteryMonitor object as a singleton.
 */
+ (ASBatteryMonitor *)sharedInstance;

@end
