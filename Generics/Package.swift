// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Generics",
    platforms: [
        .macOS(.v13),
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Generics",
            targets: ["Generics"]),
        .library(
            name: "GenericsAlt",
            targets: ["GenericsAlt"]),
    ],
    targets: [
        .target(
            name: "Generics"),
        .target(
            name: "GenericsAlt"),
        .testTarget(
            name: "GenericsTests",
            dependencies: ["Generics"]),
    ]
)
