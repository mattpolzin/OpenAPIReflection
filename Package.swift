// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "OpenAPIReflection",
    products: [
        .library(
            name: "OpenAPIReflection",
            targets: ["OpenAPIReflection"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/mattpolzin/OpenAPIKit.git", from: "2.0.0"),
        .package(url: "https://github.com/mattpolzin/OpenAPIKit.git", .revision("d96f819964a665438c15134465d334d4d3446034")),
        .package(url: "https://github.com/mattpolzin/Sampleable.git", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "OpenAPIReflection",
            dependencies: [.product(name: "OpenAPIKit30", package: "OpenAPIKit"), "Sampleable"]),
        .testTarget(
            name: "OpenAPIReflectionTests",
            dependencies: ["OpenAPIReflection"]),
    ]
)
