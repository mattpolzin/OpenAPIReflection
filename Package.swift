// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "OpenAPIReflection",
    products: [
        .library(
            name: "OpenAPIReflection",
            targets: ["OpenAPIReflection"]),
        .library(
            name: "OpenAPIReflection30",
            targets: ["OpenAPIReflection30"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mattpolzin/OpenAPIKit.git", .branch("release/3_0")),
        .package(url: "https://github.com/mattpolzin/Sampleable.git", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "OpenAPIReflection30",
            dependencies: [.product(name: "OpenAPIKit30", package: "OpenAPIKit"), "Sampleable"]),
        .testTarget(
            name: "OpenAPIReflection30Tests",
            dependencies: ["OpenAPIReflection30"]),
        .target(
            name: "OpenAPIReflection",
            dependencies: [.product(name: "OpenAPIKit", package: "OpenAPIKit"), "Sampleable"]),
        .testTarget(
            name: "OpenAPIReflectionTests",
            dependencies: ["OpenAPIReflection"]),
    ]
)
