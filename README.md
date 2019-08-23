<p align="center">
    <img src="./RxEnumKit.png" alt="RxEnumKit"/>
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" />
    <a href="https://travis-ci.org/gringoireDM/RxEnumKit">
        <img src="https://travis-ci.org/gringoireDM/RxEnumKit.svg?branch=master" alt="Build Status" />
    </a>
    <a href="https://codecov.io/gh/gringoireDM/RxEnumKit">
        <img src="https://codecov.io/gh/gringoireDM/RxEnumKit/branch/master/graph/badge.svg" />
    </a>
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/swiftPM-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
    <img src="https://cocoapod-badges.herokuapp.com/v/RxEnumKit/badge.png" alt="cocoapods" />
</p>

RxEnumKit is the reactive extension of [EnumKit](https://github.com/gringoireDM/EnumKit.git). It extends `ObservableType` and `SharedSequenceConvertibleType` to add flexibility while working with stream of enum cases.

With RxEnumKit you'll be able to extract associated values from each `CaseAccessible` enum element of the stream, map, compactMap, flatMap, filter and exclude cases.

Having a `CaseAccessible` enum, and an Observable

```swift
enum MyEvent: CaseAccessible {
    case eventA(String)
    case eventB(foo: Int)
}

let observable: Observable<MyEvent>
```

With RxEnumKit the following patterns will be possible:

```swift
observable.capture(case: MyEvent.eventA)
    .subscribe(onNext: { value in //String
        ...
    })

observable.map(case: MyEvent.eventB, String.init)
    .subscribe(onNext: { value in // String
        ...
    })
```

## Requirements

* Xcode 10.2
* Swift 5.0


## Installation

RxEnumKit offers [cocoapods](https://cocoapods.org) and [swiftPM](https://swift.org/package-manager)

### Via Cocoapods

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'RxEnumKit', '~> 1.0.1'
end
```

Replace `YOUR_TARGET_NAME` and then, in the `Podfile` directory, type:

```bash
$ pod install
```

### via Swift Package Manager

Create a `Package.swift` file.

```swift
// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "YourProjectName",
  dependencies: [
    .package(url: "https://github.com/gringoireDM/RxEnumKit.git", from: "1.0.1")
  ],
  targets: [
    .target(name: "YourProjectName", dependencies: ["RxEnumKit"])
  ]
)
```

```bash
$ swift build
```
