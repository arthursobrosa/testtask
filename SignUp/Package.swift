// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SignUp",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SignUp",
            targets: ["SignUp"]
        )
    ],
    dependencies: [
        .package(name: "Common", path: "../Common"),
        .package(name: "DesignSystem", path: "../DesignSystem")
    ],
    targets: [
        .target(
            name: "SignUp",
            dependencies: [
                .product(name: "API", package: "Common"),
                .product(name: "Components", package: "DesignSystem")
            ]
        ),
        .testTarget(
            name: "SignUpTests",
            dependencies: ["SignUp"]
        )
    ]
)
