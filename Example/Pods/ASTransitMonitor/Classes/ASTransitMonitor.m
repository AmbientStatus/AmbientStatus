//
// ASTransitMonitor.m
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

#import "ASTransitMonitor.h"

CGFloat kMinimumSpeed               = 0.3f;
CGFloat kMaximumWalkingSpeed        = 1.9f;
CGFloat kMaximumRunningSpeed        = 7.5f;
CGFloat kMinimumRunningAcceleration = 3.5f;

@interface ASTransitMonitor()

@property (strong, nonatomic)                           NSTimer                 *shakeDetectingTimer;

@property (strong, nonatomic)                           CLLocation              *currentLocation;

@property (nonatomic)                                   ASTransitState          previousTransitState;

@property (strong, nonatomic)                           CMMotionManager         *motionManager;

@property (readwrite, nonatomic)                        CMAcceleration          acceleration;

@property (strong, nonatomic)                           CMMotionActivityManager *motionActivityManager;

@property (readwrite, nonatomic, getter=isShaking)      BOOL                    shaking;
@property (readwrite, nonatomic, getter=isMonitoring)   BOOL                    monitoring;


@end

@implementation ASTransitMonitor

+ (ASTransitMonitor *)sharedInstance {
    static ASTransitMonitor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });

    return instance;
}

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleLocationChangedNotification:)
                                                     name:UIDeviceLocationDidChangeNotification
                                                   object:nil];

        _motionManager = [CMMotionManager new];
    }

    return self;
}

- (void)startMonitoring {
    [[ASLocationMonitor sharedInstance] startMonitoring];
    _monitoring = YES;

    _shakeDetectingTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(detectShaking) userInfo:nil repeats:YES];

    [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue new]
                                         withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        _acceleration = accelerometerData.acceleration;

        [self calculateTransitState];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(transitMonitor:didAccelerationChange:)]) {
                [self.delegate transitMonitor:self didAccelerationChange:_acceleration];
            }
        });
     }];

    if (_useM7IfAvailable && [CMMotionActivityManager isActivityAvailable]) {
        if (!_motionActivityManager) {
            _motionActivityManager = [CMMotionActivityManager new];
        }

        [_motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMMotionActivity *activity) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (activity.walking) {
                    _state = ASTransitStateWalking;
                }
                else if (activity.running) {
                    _state = ASTransitStateRunning;
                }
                else if (activity.automotive) {
                    _state = ASTransitStateDriving;
                }
                else if (activity.stationary || activity.unknown) {
                    _state = ASTransitStateStationary;
                }

                // If State was changed, then call delegate method
                if (_state != _previousTransitState) {
                    _previousTransitState = _state;

                    if (_delegate && [_delegate respondsToSelector:@selector(transitMonitor:didChangeTransitState:)]) {
                        [_delegate transitMonitor:self didChangeTransitState:_state];
                    }
                }
            });

        }];
    }
}

- (void)stopMonitoring {
    [_shakeDetectingTimer invalidate];

    _shakeDetectingTimer = nil;

    [[ASLocationMonitor sharedInstance] stopMonitoring];

    [_motionManager stopAccelerometerUpdates];
    [_motionActivityManager stopActivityUpdates];

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

- (CGFloat)currentSpeedAsUnit:(ASUnitType)unitType {
    switch (unitType) {
        case ASUnitTypeFeetPerSecond:
            return _speed * 3.28084;
            break;

        case ASUnitTypeYardsPerSecond:
            return _speed * 1.0936133;
            break;

        case ASUnitTypeMilesPerHour:
            return _speed * 2.23694;
            break;

        case ASUnitTypeKilometersPerHour:
            return _speed * 3.6;
            break;

        default:
            return _speed;
            break;
    }
}

#pragma mark - Customization Methods

- (void)setMinimumSpeed:(CGFloat)speed {
    kMinimumSpeed = speed;
}

- (void)setMaximumWalkingSpeed:(CGFloat)speed {
    kMaximumWalkingSpeed = speed;
}

- (void)setMaximumRunningSpeed:(CGFloat)speed {
    kMaximumRunningSpeed = speed;
}

- (void)setMinimumRunningAcceleration:(CGFloat)acceleration {
    kMinimumRunningAcceleration = acceleration;
}

#pragma mark - Private Methods

- (void)calculateTransitState {
    if (_useM7IfAvailable && [CMMotionActivityManager isActivityAvailable]) {
        return;
    }

    if (_speed < kMinimumSpeed) {
        _state = ASTransitStateStationary;
    }
    else if (_speed <= kMaximumWalkingSpeed) {
        _state = _shaking ? ASTransitStateRunning : ASTransitStateWalking;
    }
    else if (_speed <= kMaximumRunningSpeed) {
        _state = _shaking ? ASTransitStateRunning : ASTransitStateDriving;
    }
    else {
        _state = ASTransitStateDriving;
    }

    // If state was changed, then call delegate method
    if (_state != _previousTransitState) {
        _previousTransitState = _state;

        dispatch_async(dispatch_get_main_queue(), ^{
            if (_delegate && [_delegate respondsToSelector:@selector(transitMonitor:didChangeTransitState:)]) {
                [_delegate transitMonitor:self didChangeTransitState:_state];
            }
        });
    }
}

- (void)setState:(ASTransitState)state {
    [self resetTransitStates];

    _stationary = NO;

    switch (state) {
        case ASTransitStateStationary:
            _stationary = YES;
            break;

        case ASTransitStateWalking:
            _walking = YES;
            break;

        case ASTransitStateRunning:
            _running = YES;
            break;

        default:
            _driving = YES;
            break;
    }
}

- (void)resetTransitStates {
    _stationary = YES;
    _walking = NO;
    _running = NO;
    _driving = NO;

    _state = ASTransitStateStationary;
}

#pragma mark - Shaking

- (void)detectShaking {
    //Array for collecting acceleration for last one seconds period.
    static NSMutableArray *shakeDataForOneSec = nil;
    //Counter for calculating complition of one second interval
    static float currentFiringTimeInterval = 0.0f;

    currentFiringTimeInterval += 0.01f;
    if (currentFiringTimeInterval < 1.0f) {
        if (!shakeDataForOneSec)
            shakeDataForOneSec = [NSMutableArray array];

        // Add current acceleration to array
        NSValue *boxedAcceleration = [NSValue value:&_acceleration withObjCType:@encode(CMAcceleration)];
        [shakeDataForOneSec addObject:boxedAcceleration];
    }
    else {
        // Now, when one second was elapsed, calculate shake count in this interval. If the will be at least one shake then
        // we'll determine it as shaked in all this one second interval.
        int shakeCount = 0;

        for (NSValue *boxedAcceleration in shakeDataForOneSec) {
            CMAcceleration acceleration;

            [boxedAcceleration getValue:&acceleration];

            double accX_2 = powf(acceleration.x, 2);
            double accY_2 = powf(acceleration.y, 2);
            double accZ_2 = powf(acceleration.z, 2);

            double vectorSum = sqrt(accX_2 + accY_2 + accZ_2);

            if (vectorSum >= kMinimumRunningAcceleration) {
                shakeCount++;
            }
        }
        _shaking = shakeCount > 0;

        shakeDataForOneSec = nil;
        currentFiringTimeInterval = 0.0f;
    }
}

#pragma mark - LocationManager notification handler

- (void)handleLocationChangedNotification:(NSNotification *)notification {
    _currentLocation = [ASLocationMonitor sharedInstance].lastLocation;

    CGFloat _oldSpeed = _speed;
    _speed = _currentLocation.speed;

    if (_speed < 0) {
        _speed = 0;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        if (_delegate && [_delegate respondsToSelector:@selector(transitMonitor:didChangeSpeed:oldSpeed:)]) {
            [_delegate transitMonitor:self didChangeSpeed:_speed oldSpeed:_oldSpeed];
        }
    });

    [self calculateTransitState];
}

@end
