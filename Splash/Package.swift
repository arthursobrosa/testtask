// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Splash",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Splash",
            targets: ["Splash"]
        )
    ],
    dependencies: [
        .package(name: "Common", path: "../Common"),
        .package(name: "DesignSystem", path: "../DesignSystem"),
        .package(name: "Home", path: "Home")
    ],
    targets: [
        .target(
            name: "Splash",
            dependencies: [
                .product(name: "Coordinator", package: "Common"),
                .product(name: "NetworkMonitor", package: "Common"),
                .product(name: "Colors", package: "DesignSystem"),
                .product(name: "Components", package: "DesignSystem"),
                .product(name: "Fonts", package: "DesignSystem"),
                .product(name: "Home", package: "Home")
            ]
        )
    ]
)
