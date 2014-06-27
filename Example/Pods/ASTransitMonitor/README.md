# ASTransitMonitor

[![Version](https://img.shields.io/cocoapods/v/ASTransitMonitor.svg?style=flat)](http://cocoadocs.org/docsets/ASTransitMonitor)
[![License](https://img.shields.io/cocoapods/l/ASTransitMonitor.svg?style=flat)](http://cocoadocs.org/docsets/ASTransitMonitor)
[![Platform](https://img.shields.io/cocoapods/p/ASTransitMonitor.svg?style=flat)](http://cocoadocs.org/docsets/ASTransitMonitor)

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like AmbientStatus in your projects.

### Podfile, Full AmbientStatus

```ruby
platform :ios, '7.0'
pod "AmbientStatus", "~> 0.1.0"
```
### Podfile, Just ASTransitMonitor:

```ruby
platform :ios, '7.0'
pod "AmbientStatus/ASTransitMonitor"
```

## Usage

First, add the `<ASTransitMonitorDelegate>` to whichever file you'd like to use it in.

After you have done so, you have to `startMonitoring` the user's transit:

```obj-c
ASTransitMonitor *transitMonitor = [ASTransitMonitor sharedInstance]; // create new instance
transitMonitor.delegate = self; // assign the delegate to self

[transitMonitor startMonitoring]; // start monitoring the user's transit
```

After you have created a new `sharedInstance` of ASTransitMonitor, and have set the `delegate`, you can implement the following optional delegates if you desire:

```obj-c
- (void)transitMonitor:(ASTransitMonitor *)transitMonitor didChangeTransitState:(ASTransitState)transitState {
    // Do something if the user starts driving here (or has changed transit)
}
```
```obj-c
- (void)transitMonitor:(ASTransitMonitor *)transitMonitor didChangeSpeed:(CGFloat)newSpeed oldSpeed:(CGFloat)oldSpeed{
    // Do something if the user has sped up here
}
```
```obj-c
- (void)transitMonitor:(ASTransitMonitor *)transitMonitor didAccelerationChange:(CMAcceleration)acceleration{
    // Do something if the user started shaking the device here
}
```

For more help, see the [documentation](http://cocoadocs.org/docsets/ASTransitMonitor).

## Credits

[ASTransitMonitor](https://github.com/AmbientStatus/ASTransitMonitor) takes much of the code (though not verbatim) from [SOMotionDetector](https://github.com/SocialObjects-Software/SOMotionDetector) **with permission**, which was developed by [Artur Mkrtchyan (arturdev)](https://github.com/arturdev) for [SocialObjects Software](https://github.com/SocialObjects-Software).

The rest of the project was developed by [Rudd Fawcett](http://ruddfawcett.com). You can find all of his open source projects on [GitHub](https://github.com/ruddfawcett).

## Questions?

[Open an issue](https://github.com/AmbientStatus/ASTransitMonitor/issues/new).  I'll try get back to you within 24 hours.

## License

AmbientStatus and ASTransitMonitor are available under the MIT license. See the LICENSE file for more info.
