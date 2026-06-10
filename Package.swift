// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Chiselo",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "Chiselo", targets: ["Chiselo"])
    ],
    targets: [
        .executableTarget(
            name: "Chiselo",
            path: "Chiselo",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
