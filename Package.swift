// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "RxEnumKit",
    platforms: [
      .macOS(.v10_10), .iOS(.v10), .tvOS(.v10), .watchOS(.v4)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "RxEnumKit",
            targets: ["RxEnumKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.1"),
        .package(url: "https://github.com/gringoireDM/EnumKit.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "RxEnumKit",
            dependencies: ["EnumKit", "RxSwift", "RxCocoa"]),
        .testTarget(
            name: "RxEnumKitTests",
            dependencies: ["RxEnumKit", "RxTest"]),
    ]
)
