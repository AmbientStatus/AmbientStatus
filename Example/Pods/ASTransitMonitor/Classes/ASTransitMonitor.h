//
// ASTransitMonitor.h
// AmbientStatus
//
// The MIT License (MIT)
//
// Originally Created by Artur Mkrtchyan (https://github.com/arturdev)
// Copyright (c) 2014 SocialObjects Software. All rights reserved.
//
// Additionally Modified by Rudd Fawcett <rudd.fawcett@gmail.com> (http://ruddfawcett.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE

#import <CoreMotion/CoreMotion.h>

#import "ASLocationMonitor.h"

@class ASTransitMonitor;

/**
 *  @enum ASTransitState Transit states that allow you to determine users transit.
 */
typedef enum ASTransitState : NSUInteger {
    ASTransitStateStationary,
    ASTransitStateWalking,
    ASTransitStateRunning,
    ASTransitStateDriving
} ASTransitState;

/**
 *  @enum ASUnitType Unit types that allow you to convert meters per second.
 */
typedef enum ASUnitType : NSUInteger {
    ASUnitTypeKilometersPerHour,
    ASUnitTypeMilesPerHour,
    ASUnitTypeFeetPerSecond,
    ASUnitTypeMetersPerSecond,
    ASUnitTypeYardsPerSecond
} ASUnitType;

@protocol ASTransitMonitorDelegate <NSObject>


@optional

/**
 *  Detects if the transit state has changed for the user.
 *
 *  @param transitMonitor An ASTransitMonitor object.
 *  @param transitState   The State of transit that has been detected, of ASTransitState.
 */
- (void)transitMonitor:(ASTransitMonitor *)transitMonitor didChangeTransitState:(ASTransitState)transitState;

/**
 *  Detects if the user has sped up or slowed down.
 *
 *  @param transitMonitor An ASTransitMonitor object.
 *  @param speed          The current speed of the device.
 *  @param oldSpeed       The old speed that the newSpeed changed from.
 */
- (void)transitMonitor:(ASTransitMonitor *)transitMonitor didChangeSpeed:(CGFloat)newSpeed oldSpeed:(CGFloat)oldSpeed;

/**
 *  Detects if the user has started shaking the device.
 *
 *  @param transitMonitor An ASTransitMonitor object.
 *  @param acceleration   The acceleration of the device.
 */
- (void)transitMonitor:(ASTransitMonitor *)transitMonitor didAccelerationChange:(CMAcceleration)acceleration;

@end

@interface ASTransitMonitor : NSObject

#pragma mark - Properties

/**
 *  @property state The transit state of the user.
 */
@property (readonly, nonatomic)                      ASTransitState               state;

/**
 *  @property acceleration The acceleration at which the user is shaking the device.
 */
@property (readonly, nonatomic)                      CMAcceleration               acceleration;

/**
 *  @property speed The current speed of the user in meters per second.
 */
@property (readonly, nonatomic)                      CGFloat                       speed;

/**
 *  The following readonly properties add getters to an ASTransitMonitor object.
 *  
 *  @property stationary
 *  @property walking
 *  @property running
 *  @property driving
 *  
 *  They allow you to check for a specific state of transit.
 */
@property (readonly, nonatomic, getter=isStationary) BOOL                         stationary;
@property (readonly, nonatomic, getter=isWalking)    BOOL                         walking;
@property (readonly, nonatomic, getter=isRunning)    BOOL                         running;
@property (readonly, nonatomic, getter=isDriving)    BOOL                         driving;

/**
 *  @property monitoring Tells you if ASBatteryMonitor is currently listening for changes in battery
 *                       state and level.
 */
@property (readonly, nonatomic, getter=isMonitoring) BOOL                         monitoring;

/**
 *  @property shaking Tells you if the device is being shaken.
 */
@property (readonly, nonatomic, getter=isShaking)    BOOL                         shaking;

/**
 *  @property useM7IfAvailable
 *
 *  Set this parameter to YES if you want to use M7 chip to detect more exact motion State. The default is NO.
 *  Set this parameter before calling the startMonitoring method.
 *  Available only on devices that have M7 chip. At this time only the iPhone 5S, the iPad Air and iPad mini with
 *  retina display have the M7 coprocessor.
 *
 *  #define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
 *
 *  if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
 *      [ASTransitMonitor sharedInstance].useM7IfAvailable = YES;
 *  }
 *
 *  [[ASTransitMonitor sharedInstance] startMonitoring];
 *
 */
@property (nonatomic)                                BOOL                         useM7IfAvailable NS_AVAILABLE_IOS(7_0);

/**
 *  @property delegate The delegate which allows you to run your own methods upon transit state being changed.
 */
@property (weak, nonatomic)                          id<ASTransitMonitorDelegate> delegate;

#pragma mark - Monitoring Methods

/**
 *  Starts the monitoring of the transit status.
 */
- (void)startMonitoring;

/**
 *  Stops the monitoring of the transit status.
 */
- (void)stopMonitoring;

/**
 *  Toggles the monitoring of the transit status.
 */
- (void)toggleMonitoring;

#pragma mark - Customization Methods

/**
 *  @param speed The minimum speed value less than which will be considered as stationary state.
 */
- (void)setMinimumSpeed:(CGFloat)speed;

/**
 *  @param speed The maximum speed value more than which will be considered as running state.
 */
- (void)setMaximumWalkingSpeed:(CGFloat)speed;

/**
 *  @param speed The maximum speed value more than which will be considered as automotive state.
 */
- (void)setMaximumRunningSpeed:(CGFloat)speed;

/**
 *  @param acceleration The minimum acceleration value less than which will be considered as non shaking state.
 */
- (void)setMinimumRunningAcceleration:(CGFloat)acceleration;

#pragma mark - Convenience Methods

- (CGFloat)currentSpeedAsUnit:(ASUnitType)unitType;

#pragma mark - Singleton

/**
 *  ASTransitMonitor singleton.
 *
 *  @return ASTransitMonitor object as a singleton.
 */

+ (ASTransitMonitor *)sharedInstance;

@end
