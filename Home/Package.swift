// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Home",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Home",
            targets: ["Home"]
        )
    ],
    dependencies: [
        .package(name: "DesignSystem", path: "../DesignSystem"),
        .package(name: "SignUp", path: "../SignUp"),
        .package(name: "Users", path: "../Users")
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: [
                .product(name: "Components", package: "DesignSystem"),
                .product(name: "SignUp", package: "SignUp"),
                .product(name: "Users", package: "Users")
            ]
        ),
        .testTarget(
            name: "HomeTests",
            dependencies: ["Home"]
        )
    ]
)
