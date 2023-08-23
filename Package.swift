// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftRetrier",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15)
        // .macOS(.v12)
    ],
    products: [
        .library(
            name: "SwiftRetrier",
            targets: ["SwiftRetrier"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftRetrier",
            dependencies: [],
            plugins: []
        ),
        .testTarget(
            name: "SwiftRetrierTests",
            dependencies: ["SwiftRetrier"],
            plugins: []
        )
    ]
)
