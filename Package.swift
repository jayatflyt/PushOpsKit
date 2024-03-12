// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PushOpsKit",
    platforms: [
        .iOS("13.0"),
        .macOS("10.15"),
        .watchOS("6")
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PushOpsKit",
            targets: ["PushOpsKit"]),
    ],
    dependencies: [
        .package(
              url: "https://github.com/apple/swift-collections.git",
              .upToNextMajor(from: "1.0.0") // or `.upToNextMajor
            )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PushOpsKit",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ]
        ),
        .testTarget(
            name: "PushOpsKitTests",
            dependencies: ["PushOpsKit"]),
    ]
)

/**
 Failed to resolve dependencies Dependencies could not be resolved because no versions of 'swift-collections' match the requirement 1.1.0..<1.2.0 and root depends on 'swift-collections' 1.1.0..<1.2.0.
**/
