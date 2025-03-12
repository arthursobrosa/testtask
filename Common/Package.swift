// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Common",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Coordinator",
            targets: ["Coordinator"]
        ),
        .library(
            name: "API",
            targets: ["API"]
        ),
        .library(
            name: "NetworkMonitor",
            targets: ["NetworkMonitor"]
        )
    ],
    targets: [
        .target(
            name: "Coordinator"
        ),
        .target(
            name: "API"
        ),
        .target(
            name: "NetworkMonitor"
        )
    ]
)
