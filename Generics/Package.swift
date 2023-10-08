// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

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
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", branch: "main"),
    ],
    targets: [
        .macro(name: "GenericsMacros", dependencies: [
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
        ]),
        .target(
            name: "Generics", dependencies: [
                "GenericsMacros"
            ]),
        .target(
            name: "GenericsAlt", dependencies: [
                "GenericsMacros"
            ]),
        .testTarget(name: "GenericsTests", dependencies: ["Generics"]),
        .testTarget(name: "GenericsAltTests", dependencies: ["GenericsAlt"]),
    ]
)
