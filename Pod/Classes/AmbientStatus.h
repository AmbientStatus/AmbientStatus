//
// AmbientStatus.h
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

#pragma mark - Frameworks Used

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#pragma mark - AmbientStatus Classes

#if __has_include(<ASBatteryMonitor/ASBatteryMonitor.h>)
#import <ASBatteryMonitor/ASBatteryMonitor.h>
#endif

#if (__has_include(<ASTransitMonitor/ASTransitMonitor.h>) && __has_include(<ASLocationMonitor/ASLocationMonitor.h>)) || __has_include(<ASTransitMonitor/ASTransitMonitor.h>)
#import <ASTransitMonitor/ASTransitMonitor.h>
#import <ASLocationMonitor/ASLocationMonitor.h>
#elif __has_include(<ASLocationMonitor/ASLocationMonitor.h>) && !__has_include(<ASTransitMonitor/ASTransitMonitor.h>)
#import <ASLocationMonitor/ASLocationMonitor.h>
#endif
