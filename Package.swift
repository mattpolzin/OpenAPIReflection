// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenAPIReflection",
    products: [
        .library(
            name: "OpenAPIReflection",
            targets: ["OpenAPIReflection"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mattpolzin/OpenAPIKit.git", .upToNextMinor(from: "0.29.0")),
        .package(url: "https://github.com/mattpolzin/Sampleable.git", .upToNextMajor(from: "2.1.0"))
    ],
    targets: [
        .target(
            name: "OpenAPIReflection",
            dependencies: ["OpenAPIKit", "Sampleable"]),
        .testTarget(
            name: "OpenAPIReflectionTests",
            dependencies: ["OpenAPIReflection"]),
    ]
)
