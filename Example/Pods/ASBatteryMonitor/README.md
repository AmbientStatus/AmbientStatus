# ASBatteryMonitor

[![Version](https://img.shields.io/cocoapods/v/ASBatteryMonitor.svg?style=flat)](http://cocoadocs.org/docsets/AmbientStatus)
[![License](https://img.shields.io/cocoapods/l/ASBatteryMonitor.svg?style=flat)](http://cocoadocs.org/docsets/AmbientStatus)
[![Platform](https://img.shields.io/cocoapods/p/ASBatteryMonitor.svg?style=flat)](http://cocoadocs.org/docsets/AmbientStatus)

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like AmbientStatus in your projects.

### Podfile, Full AmbientStatus

```ruby
platform :ios, '7.0'
pod "AmbientStatus", "~> 0.1.0"
```
### Podfile, Just ASBatteryMonitor:

```ruby
platform :ios, '7.0'
pod "AmbientStatus/ASBatteryMonitor"
```

## Usage

First, add the `<ASBatteryMonitorDelegate>` to whichever file you'd like to use it in.

After you have done so, you have to `startMonitoring` the user's battery:

```obj-c
ASBatteryMonitor *batteryMonitor = [ASBatteryMonitor sharedInstance]; // create new instance
batteryMonitor.delegate = self; // assign the delegate to self

[batteryMonitor startMonitoring]; // start monitoring the user's battery
```

After you have created a new `sharedInstance` of ASBatteryMonitor, and have set the `delegate`, you can implement the following optional delegates if you desire:

```obj-c
- (void)batteryMonitor:(ASBatteryMonitor *)batteryMonitor didChangeBatteryState:(UIDeviceBatteryState)state {
    // Do something with the new battery state here
}
```

```obj-c
- (void)batteryMonitor:(ASBatteryMonitor *)batteryMonitor didChangeBatteryLevel:(CGFloat)level {
    // Do something with the new battery percentage here
}
```

For more help, see the [documentation](http://cocoadocs.org/docsets/ASBatteryMonitor).

## Credits

Developed by [Rudd Fawcett](http://ruddfawcett.com). You can find all of his open source projects on [GitHub](https://github.com/ruddfawcett).

## Questions?

[Open an issue](https://github.com/AmbientStatus/ASBatteryMonitor/issues/new).  I'll try get back to you within 24 hours.

## License

AmbientStatus and ASBatteryMonitor are available under the MIT license. See the LICENSE file for more info.
