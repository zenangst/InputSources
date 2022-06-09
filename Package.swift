// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "InputSources",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "InputSources", targets: ["InputSources"]),
    ],
    targets: [
        .target(
            name: "InputSources",
            dependencies: [ ]),
        .testTarget(
            name: "InputSourcesTests",
            dependencies: ["InputSources"]),
    ]
)

