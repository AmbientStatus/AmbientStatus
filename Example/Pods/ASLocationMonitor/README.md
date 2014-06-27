# ASLocationMonitor

[![Version](https://img.shields.io/cocoapods/v/ASLocationMonitor.svg?style=flat)](http://cocoadocs.org/docsets/ASLocationMonitor)
[![License](https://img.shields.io/cocoapods/l/ASLocationMonitor.svg?style=flat)](http://cocoadocs.org/docsets/ASLocationMonitor)
[![Platform](https://img.shields.io/cocoapods/p/ASLocationMonitor.svg?style=flat)](http://cocoadocs.org/docsets/ASLocationMonitor)

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like AmbientStatus in your projects.

### Podfile, Full AmbientStatus

```ruby
platform :ios, '7.0'
pod "AmbientStatus", "~> 0.1.0"
```
### Podfile, Just ASLocationMonitor:

```ruby
platform :ios, '7.0'
pod "AmbientStatus/ASLocationMonitor"
```

## Usage

First, add the `<ASLocationMonitorDelegate>` to whichever file you'd like to use it in.

After you have done so, you have to `startMonitoring` the user's transit:

```obj-c
ASLocationMonitor *locationMonitor = [ASLocationMonitor sharedInstance]; // create new instance
locationMonitor.delegate = self; // assign the delegate to self

[locationMonitor startMonitoring]; // start monitoring the user's location
```

After you have created a new `sharedInstance` of ASTransitMonitor, and have set the `delegate`, you can implement the following optional delegates if you desire:

```obj-c
- (void)locationMonitor:(ASLocationMonitor *)locationMonitor didEnterNeighborhood:(CLLocation *)location {
    // Do something if the user entered within the neighborhood of a location
}
```

```obj-c
- (void)locationMonitor:(ASLocationMonitor *)locationMonitor didExitNeighborhood:(CLLocation *)location;
    // Do something if the user exited the neighborhood they had previously entered
```

For more help, see the [documentation](http://cocoadocs.org/docsets/ASLocationMonitor).

## Credits

Developed by [Rudd Fawcett](http://ruddfawcett.com). You can find all of his open source projects on [GitHub](https://github.com/ruddfawcett).

## Questions?

[Open an issue](https://github.com/AmbientStatus/ASLocationMonitor/issues/new).  I'll try get back to you within 24 hours.

## License

AmbientStatus and ASLocationMonitor are available under the MIT license. See the LICENSE file for more info.
