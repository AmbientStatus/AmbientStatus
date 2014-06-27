//
// NSString+Convenience.m
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

#import "NSString+Convenience.h"

@implementation NSString (Convenience)

+ (NSString *)floatToPercentString:(CGFloat)originalFloat {
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    numberFormatter.maximumFractionDigits = 1;
    
    return [numberFormatter stringFromNumber:@(originalFloat)];
}

+ (NSString *)batteryStateToString:(UIDeviceBatteryState)batteryState {
    switch (batteryState) {
        case UIDeviceBatteryStateCharging:
            return @"Charging";
            break;
            
        case UIDeviceBatteryStateFull:
            return @"Full";
            break;
            
        case UIDeviceBatteryStateUnplugged:
            return @"Unplugged";
            break;
            
        default:
            return @"Unknown";
            break;
    }
    
    return nil;
}

+ (NSString *)transitStateToString:(ASTransitState)transitState {
    switch (transitState) {
        case ASTransitStateWalking:
            return @"Walking";
            break;
            
        case ASTransitStateRunning:
            return @"Running";
            break;
            
        case ASTransitStateDriving:
            return @"Driving";
            break;
            
        default:
            return @"Stationary";
            break;
    }
    
    return nil;
}

@end
