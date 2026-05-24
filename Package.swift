// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ios-ai-executor",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "IOSAIExecutor", targets: ["IOSAIExecutor"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "IOSAIExecutor",
            path: "Sources"
        )
    ]
)
