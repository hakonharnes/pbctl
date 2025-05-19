// swift-tools-version: 6.0.3

import PackageDescription

let package = Package(
    name: "pbctl",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.5.0"
        ),
        .package(
            url: "https://github.com/hakonharnes/CLibmagic.git",
            from: "0.7.4"
        )
    ],

    targets: [
        .executableTarget(
            name: "pbctl",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "MagicWrapper", package: "CLibmagic")
            ]
        )
    ]
)
