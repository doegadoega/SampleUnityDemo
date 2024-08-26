// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "UnityFramework",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "UnityFramework",
            targets: ["UnityFramework"]),
    ],
    targets: [
        .binaryTarget(
            name: "UnityFramework",
            path: "./Frameworks/UnityFramework.framework"
        )
    ]
)

