//
// ASBatteryMonitor.m
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

#import "ASBatteryMonitor.h"

@interface ASBatteryMonitor ()

@property (readwrite, nonatomic, getter=isFull)         BOOL                  full;
@property (readwrite, nonatomic, getter=isCharging)     BOOL                  charging;
@property (readwrite, nonatomic, getter=isUnplugged)    BOOL                  unplugged;
@property (readwrite, nonatomic, getter=isUnknown)      BOOL                  unknown;
@property (readwrite, nonatomic, getter=isMonitoring)   BOOL                  monitoring;

@property (readwrite, nonatomic)                        UIDeviceBatteryState  state;

@property (readwrite, nonatomic)                        CGFloat               percentage;

@end

@implementation ASBatteryMonitor

+ (ASBatteryMonitor *)sharedInstance {
    __strong static ASBatteryMonitor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });

    return instance;
}

- (void)startMonitoring {
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter addObserver:self
                           selector:@selector(batteryLevelDidChange:)
                               name:UIDeviceBatteryLevelDidChangeNotification object:nil];

    [notificationCenter addObserver:self
                           selector:@selector(batteryStateDidChange:)
                               name:UIDeviceBatteryStateDidChangeNotification object:nil];

    _monitoring = YES;

    [self batteryStateDidChange:nil];
}

- (void)stopMonitoring {
    [UIDevice currentDevice].batteryMonitoringEnabled = NO;

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    _monitoring = NO;

    [self batteryStateDidChange:nil];
}

- (void)toggleMonitoring {
    if (_monitoring) {
        [self stopMonitoring];
    }
    else {
        [self startMonitoring];
    }
}

- (void)batteryLevelDidChange:(NSNotification *)notification {
    [self updateBatteryLevel];
}

- (void)batteryStateDidChange:(NSNotification *)notification {
    [self updateBatteryLevel];
    [self updateBatteryState];
}

- (void)updateBatteryLevel {
    _percentage = [UIDevice currentDevice].batteryLevel;

    dispatch_async(dispatch_get_main_queue(), ^{
        if (_delegate && [_delegate respondsToSelector:@selector(batteryMonitor:didChangeBatteryLevel:)]) {
            [_delegate batteryMonitor:self didChangeBatteryLevel:_percentage];
        }
    });
}

- (void)updateBatteryState {
    UIDeviceBatteryState currentState = [UIDevice currentDevice].batteryState;

    [self resetBatteryStates];

    _state = currentState;

    dispatch_async(dispatch_get_main_queue(), ^{
        if (_delegate && [_delegate respondsToSelector:@selector(batteryMonitor:didChangeBatteryState:)]) {
            [_delegate batteryMonitor:self didChangeBatteryState:_state];
        }
    });
}

- (void)setState:(UIDeviceBatteryState)state {
    _unknown = NO;
    switch (state) {
        case UIDeviceBatteryStateFull:
            _full = YES;
            break;

        case UIDeviceBatteryStateCharging:
            _charging = YES;
            break;

        case UIDeviceBatteryStateUnplugged:
            _unplugged = YES;
            break;

        default:
            _unknown = YES;
            break;
    }
}

- (void)resetBatteryStates {
    _full = NO;
    _charging = NO;
    _unplugged = NO;
    _unknown = YES;

    _state = UIDeviceBatteryStateUnknown;
}

@end
