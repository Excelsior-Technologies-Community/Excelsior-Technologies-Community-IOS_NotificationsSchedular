// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NotificationSchedul",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "NotificationSchedul",
            targets: ["NotificationSchedul"]
        ),
    ],
    targets: [
        .target(
            name: "NotificationSchedul",
            resources: [
                .process("Assets.xcassets"),
                .process("Sounds")
            ]
        ),
        .testTarget(
            name: "NotificationSchedulTests",
            dependencies: ["NotificationSchedul"]
        )
    ]
)
