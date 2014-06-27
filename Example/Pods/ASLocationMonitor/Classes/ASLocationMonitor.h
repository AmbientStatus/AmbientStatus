//
// ASLocationMonitor.h
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

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define UIDeviceLocationDidChangeNotification @"UIDeviceLocationDidChangeNotification"
#define UIDeviceLocationDidFailNotification @"UIDeviceLocationDidChangeNotification"

@class ASLocationMonitor;

@protocol ASLocationMonitorDelegate <NSObject>


@optional

/**
 *  Detects if a user has entered a location's neighborhood (has entered within radius of).
 *
 *  @param locationMonitor An ASLocationMonitor object.
 *  @param location        The location from which the radius is calculated.
 */
- (void)locationMonitor:(ASLocationMonitor *)locationMonitor didEnterNeighborhood:(CLLocation *)location;

/**
 *  If the user had previously entered a radius of a location, this method will be called when they exit it.
 *
 *  @param locationMonitor An ASLocationMonitor object.
 *  @param location        The location from which the radius is calculated.
 */
- (void)locationMonitor:(ASLocationMonitor *)locationMonitor didExitNeighborhood:(CLLocation *)location;

/**
 *  Detects if a user has entered locations' neighborhoods (has entered within radius of).
 *
 *  @param locationMonitor An ASLocationMonitor object.
 *  @param location        The location from which the radii are calculated.
 */
- (void)locationMonitor:(ASLocationMonitor *)locationMonitor didEnterNeighborhoods:(NSArray *)locations;

/**
 *  If the user had previously entered a radius of a location, this method will be called when they exit them.
 *
 *  @param locationMonitor An ASLocationMonitor object.
 *  @param locations       The locations from which the radii are calculated.
 */
- (void)locationMonitor:(ASLocationMonitor *)locationMonitor didExitNeighborhoods:(NSArray *)locations;

@end

@interface ASLocationMonitor : NSObject <CLLocationManagerDelegate>

#pragma mark - Properties

/**
 *  @property locationsToMonitor The locations to watch out for and monitor
 */
@property (readwrite, strong, nonatomic)             NSMutableArray                *locationsToMonitor;

/**
 *  @property lastLocation The last location of the user.
 */
@property (readonly, nonatomic)                      CLLocation                    *lastLocation;

/**
 *  @property lastCoordinate The last coordinate of the user, taken from the last location.
 */
@property (readonly, nonatomic)                      CLLocationCoordinate2D        lastCoordinate;

/**
 *  @property monitoring Whethor or not ASLocationMonitor is currently monitoring.
 */
@property (readonly, nonatomic, getter=isMonitoring) BOOL                          monitoring;

/**
 *  @property delegate The delegate which allows you to run your own methods upon location being changed.
 */
@property (weak, nonatomic)                          id<ASLocationMonitorDelegate> delegate;

#pragma mark - Monitoring Methods

/**
 *  Starts the monitoring of location.
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
 *  @param distance The maximum radius distance from a point in order to form "neighborhood."
 */
- (void)setMaximumRadiusDistance:(CGFloat)distance;

#pragma mark - Singleton

/**
 *  ASLocationMonitor singleton.
 *
 *  @return ASLocationMonitor object as a singleton.
 */

+ (ASLocationMonitor *)sharedInstance;

@end
