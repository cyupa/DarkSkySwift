## DarkSkySwift
# DarkSky API Swift Framework

[![Swift](https://img.shields.io/badge/Swift-4.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/cocoapods/p/DarkSkySwift.svg)](https://cocoapods.org/pods/DarkSkySwift)
[![License](https://img.shields.io/cocoapods/l/DarkSkySwift.svg)](https://raw.githubusercontent.com/cyupa/DarkSkySwift/master/LICENSE)

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/DarkSkySwift.svg)](https://cocoapods.org/pods/DarkSkySwift)

[![Travis](https://img.shields.io/travis/cyupa/DarkSkySwift/master.svg)](https://travis-ci.org/cyupa/DarkSkySwift/branches)[![codebeat badge](https://codebeat.co/badges/7bbe6bb2-c918-4daf-bb5b-a3611cec7105)](https://codebeat.co/projects/github-com-cyupa-darkskyswift-master)

This is my first attempt at writing a Swift framework. I decided to go with the DarkSky API for this experiment and Swift 4's brand new Codable protocol.
Please treat it as an experiment rather than an production-ready framework.

The DarkSky API is build on top of a more generic networking API that I intend to extend in the future, **at this point it lacks a lot of support for things such as**:
- Multipart requests
- Custom HTTP body data
- Caching

## Content
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Requirements

- iOS 8.0+ / Mac OS X 10.10+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 9.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build DarkSkySwift 0.0.1+.

To integrate DarkSkySwift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'DarkSkySwift', '~> 0.0.1'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate DarkSkySwift into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "DarkSkySwift/DarkSkySwift" ~> 0.0.1
```
### Swift Package Manager

To use DarkSkySwift as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following in your Package.swift file.

``` swift
import PackageDescription

let package = Package(
    name: "HelloDarkSkySwift",
    dependencies: [
        .Package(url: "https://github.com/cyupa/DarkSkySwift.git", "0.0.1")
    ]
)
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate DarkSkySwift into your project manually.

#### Git Submodules

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add DarkSkySwift as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/cyupa/DarkSkySwift.git
$ git submodule update --init --recursive
```

- Open the new `DarkSkySwift` folder, and drag the `DarkSkySwift.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `DarkSkySwift.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `DarkSkySwift.xcodeproj` folders each with two different versions of the `DarkSkySwift.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from.

- Select the `DarkSkySwift.framework`.

- And that's it!

> The `DarkSkySwift.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

#### Embeded Binaries

- Download the latest release from https://github.com/cyupa/DarkSkySwift/releases
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- Add the downloaded `DarkSkySwift.framework`.
- And that's it!

## Usage

## License

DarkSkySwift is released under the MIT license. See [LICENSE](https://github.com/cyupa/DarkSkySwift/blob/master/LICENSE) for details.
