//
// NSString+Convenience.h
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

#import "ASTransitMonitor.h"

@interface NSString (Convenience)

/**
 *  Converts a CGFloat to a string with percentage sign and non-decimal value.
 *
 *  @param originalFloat The original CGFloat that will be reformatted
 *
 *  @return NSString     The string that will be returned.  Ex. 0.3 (put in) -> 30% (put out).
 */
+ (NSString *)floatToPercentString:(CGFloat)originalFloat;

/**
 *  Takes a UIDeviceBatteryState and converts it to a string.  Added more for convenience of demo,
 *  but may come in handy for some.
 *
 *  @param batteryState The UIDeviceBatteryState to be converted.
 *
 *  @return NSString    The string that will be returned.  Ex. UIDeviceBatteryStateFull (put in) -> Full (put out).
 */
+ (NSString *)batteryStateToString:(UIDeviceBatteryState)batteryState;

/**
 *  Takes a ASTransitState and converts it to a string.  Added more for convenience of demo,
 *  but may come in handy for some.
 *
 *  @param transitState The ASTransitState to be converted.
 *
 *  @return NSString    The string that will be returned.  Ex. ASTransitStateWalking (put in) -> Walking (put out).
 */
+ (NSString *)transitStateToString:(ASTransitState)transitState;

@end
