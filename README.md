# AmbientStatus

[![CI Status](http://img.shields.io/travis/AmbientStatus/AmbientStatus.svg?style=flat)](https://travis-ci.org/AmbientStatus/AmbientStatus)
[![Version](https://img.shields.io/cocoapods/v/AmbientStatus.svg?style=flat)](http://cocoadocs.org/docsets/AmbientStatus)
[![License](https://img.shields.io/cocoapods/l/AmbientStatus.svg?style=flat)](http://cocoadocs.org/docsets/AmbientStatus)
[![Platform](https://img.shields.io/cocoapods/p/AmbientStatus.svg?style=flat)](http://cocoadocs.org/docsets/AmbientStatus)

Seamlesssly update your app based on the ambiance of your users.  Inspired by "Path Talk - The New Messenger," AmbientStatus offers all of the same "Ambient Status" features, with more to come.

> *From Path's "Path Talk - The New Messenger" Description*:
>
> Ambient Status:  Path talk can automatically tell your friends when you're in transit, in the neighborhood, or even low on battery so your availability is always understood &mdash; removing the headache of misunderstandings in conversation.

AmbientStatus provides delegates and properties for all of the features in the description above:
- **[Transit Monitor](https://github.com/AmbientStatus/ASTransitMonitor) `ASTransitMonitor`**
  - Whether the user is in transit, and the type of transit (Stationary, Walking, Running or Driving), and notifications of any change.
- **[Battery Monitor](https://github.com/AmbientStatus/ASBatteryMonitor) `ASBatteryMonitor`**
  - Provides battery percentage and state (Unknown, Unplugged, Charging or Full) for up to date battery level, and notifications of any change.
- **[Location Monitor](https://github.com/AmbientStatus/ASLocationMonitor) `ASLocationMonitor`** (Untested)
  - Detects if the user has entered within a `kMaximumRadius` of a location (`CLLocation`), and provides feedback upon leaving the area.

**AmbientStatus was planned to have a single header file - AmbientStatus.h - that was going to [conditionally include headers](Pod/Classes/AmbientStatus.h) based on [subspecs installed](AmbientStatus.podspec#L32).  This is not working.  See [issue #1](https://github.com/AmbientStatus/AmbientStatus/issues/1) if you have any thoughts, please!**

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like AmbientStatus in your projects.

### Podfile, Full AmbientStatus

```ruby
platform :ios, '7.0'
pod "AmbientStatus", "~> 0.1.0"
```
### Podfile, Individual Monitors:

```ruby
platform :ios, '7.0'
pod "AmbientStatus/ASTransitMonitor"
pod "AmbientStatus/ASBatteryMonitor"
pods "AmbientStatus/ASLocationMonitor"
```
## Trying it Out

### Trying the Demo
If you are just looking to try the demo project, run the following in Terminal:
```bash
$ gem install cocoapods-try && pod try AmbientStatus
```
### Trying Demo (without `pod try`)
```bash
$ git clone https://github.com/AmbientStatus/AmbientStatus
$ cd AmbientStatus/Example && pod install
```

## Usage

Find updated usage guidelines at each pod's individual repo:
- [ASTransitMonitor](https://github.com/AmbientStatus/ASTransitMonitor)
- [ASBatteryMonitor](https://github.com/AmbientStatus/ASBatteryMonitor)
- [ASLocationMonitor](https://github.com/AmbientStatus/ASLocationMonitor)

## Credits

[ASTransitMonitor](https://github.com/AmbientStatus/ASTransitMonitor) takes much of the code (though not verbatim) from [SOMotionDetector](https://github.com/SocialObjects-Software/SOMotionDetector) **with permission**, which was developed by [Artur Mkrtchyan (arturdev)](https://github.com/arturdev) for [SocialObjects Software](https://github.com/SocialObjects-Software).

The rest of the project was developed by [Rudd Fawcett](http://ruddfawcett.com). You can find all of his open source projects on [GitHub](https://github.com/ruddfawcett).

## Questions?

[Open an issue](https://github.com/AmbientStatus/AmbientStatus/issues/new).  I'll try get back to you within 24 hours.

## License

AmbientStatus is available under the MIT license. See the LICENSE file for more info.
