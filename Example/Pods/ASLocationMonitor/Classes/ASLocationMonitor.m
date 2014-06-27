//
// ASLocationMonitor.m
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

#import "ASLocationMonitor.h"

CGFloat kMaximumRadius = 1000; // A kilometer

@interface ASLocationMonitor ()

@property (readwrite, nonatomic, getter=isMonitoring)   BOOL                   monitoring;

@property (readwrite, nonatomic)                        CLLocationManager      *locationManager;

@property (readwrite, nonatomic)                        CLLocation             *lastLocation;

@property (readwrite, nonatomic)                        CLLocationCoordinate2D lastCoordinate;

@property (strong, nonatomic)                           NSMutableArray          *enteringLocations;

@end

@implementation ASLocationMonitor

- (id)init {
    if (self = [super init]) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.delegate = self;
    }

    return self;
}

+ (ASLocationMonitor *)sharedInstance {
    __strong static ASLocationMonitor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });

    return instance;
}

- (void)startMonitoring {
    [self.locationManager startUpdatingLocation];
    [self.locationManager startMonitoringSignificantLocationChanges];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkLocations:)
                               name:UIDeviceLocationDidChangeNotification object:nil];

    _monitoring = YES;
}

- (void)stopMonitoring {
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    _monitoring = NO;
}

- (void)toggleMonitoring {
    if (_monitoring) {
        [self stopMonitoring];
    }
    else {
        [self startMonitoring];
    }
}

- (void)checkLocations:(NSNotification *)notification {
    for (id eachLocation in _locationsToMonitor) {
        if ([eachLocation isKindOfClass:[CLLocation class]] && [eachLocation distanceFromLocation:_lastLocation] <= kMaximumRadius) {
            [_enteringLocations addObject:eachLocation];
        }
    }

    NSMutableArray *potentialExits = [_enteringLocations copy];

    if (_enteringLocations.count == 0) {
        return;
    }
    else if (_enteringLocations.count == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_delegate && [_delegate respondsToSelector:@selector(locationMonitor:didEnterNeighborhood:)]) {
                [_delegate locationMonitor:self didEnterNeighborhood:[_enteringLocations objectAtIndex:0]];
            }
        });
    }
    else if (_enteringLocations.count > 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_delegate && [_delegate respondsToSelector:@selector(locationMonitor:didEnterNeighborhoods:)]) {
                [_delegate locationMonitor:self didEnterNeighborhoods:_enteringLocations];
            }
        });
    }

    NSMutableArray *finalExits = [NSMutableArray new];

    for (CLLocation *eachLocation in potentialExits) {
        if ([eachLocation distanceFromLocation:_lastLocation] > kMaximumRadius) {
            [_enteringLocations removeObject:eachLocation];
            [finalExits addObject:eachLocation];
        }
    }

    if (finalExits.count == 0) {
        return;
    }
    else if (finalExits.count == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_delegate && [_delegate respondsToSelector:@selector(locationMonitor:didExitNeighborhood:)]) {
                [_delegate locationMonitor:self didExitNeighborhood:[finalExits objectAtIndex:0]];
            }
        });
    }
    else if (finalExits.count > 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_delegate && [_delegate respondsToSelector:@selector(locationMonitor:didExitNeighborhoods:)]) {
                [_delegate locationMonitor:self didExitNeighborhoods:finalExits];
            }
        });
    }
}

#pragma mark - Customization Methods

- (void)setMaximumRadiusDistance:(CGFloat)distance {
    kMaximumRadius = distance;
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];

    self.lastLocation = location;
    self.lastCoordinate = location.coordinate;

    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceLocationDidChangeNotification
                                                        object:location
                                                      userInfo:@{@"location" : location}];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceLocationDidFailNotification
                                                        object:error
                                                      userInfo:@{@"error" : error}];
}

@end
