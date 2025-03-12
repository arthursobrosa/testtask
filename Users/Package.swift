// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Users",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Users",
            targets: ["Users"]
        )
    ],
    dependencies: [
        .package(name: "Common", path: "../Common"),
        .package(name: "DesignSystem", path: "../DesignSystem")
    ],
    targets: [
        .target(
            name: "Users",
            dependencies: [
                .product(name: "API", package: "Common"),
                .product(name: "Colors", package: "DesignSystem"),
                .product(name: "Fonts", package: "DesignSystem")
            ]
        ),
        .testTarget(
            name: "UsersTests",
            dependencies: ["Users"]
        )
    ]
)
