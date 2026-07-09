// swift-tools-version: 5.9.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
// swift-tools-version: 5.9.0
import PackageDescription

let package = Package(
    name: "ARProductViewer",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "ARProductViewer",
            targets: ["ARProductViewer"]
        ),
    ],
    targets: [
        .target(
            name: "ARProductViewer",
            dependencies: [],
            path: "Sources/ARProductViewer"
        ),
    ]
)
