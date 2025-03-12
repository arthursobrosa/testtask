// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Colors",
            targets: ["Colors"]
        ),
        .library(
            name: "Components",
            targets: ["Components"]
        ),
        .library(
            name: "Fonts",
            targets: ["Fonts"]
        )
    ],
    targets: [
        .target(
            name: "Colors"
        ),
        .target(
            name: "Components",
            dependencies: [
                "Fonts",
                "Colors"
            ]
        ),
        .target(
            name: "Fonts",
            resources: [
                .process("NunitoSans7pt-Regular.ttf"),
                .process("NunitoSans7pt-Semibold.ttf")
            ]
        )
    ]
)
