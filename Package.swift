// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-favicon",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: "Favicon", targets: ["Favicon"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.6.0"),
        .package(url: "https://github.com/pointfreeco/swift-url-routing", from: "0.6.0"),
        .package(url: "https://github.com/coenttb/swift-html", from: "0.8.0"),
    ],
    targets: [
        // Domain module with all functionality
        .target(
            name: "Favicon",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "URLRouting", package: "swift-url-routing"),
                .product(name: "HTML", package: "swift-html"),
            ]
        ),
        // Tests
        .testTarget(
            name: "FaviconTests",
            dependencies: [
                "Favicon",
                .product(name: "HTML", package: "swift-html"),
                .product(name: "DependenciesTestSupport", package: "swift-dependencies"),
            ],
            exclude: ["Favicon.xctestplan"]
        ),
    ]
)

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("StrictUnsafe"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .unsafeFlags(["-warnings-as-errors"]),
    // .unsafeFlags([
    //   "-Xfrontend",
    //   "-warn-long-function-bodies=50",
    //   "-Xfrontend",
    //   "-warn-long-expression-type-checking=50",
    // ])
]

for index in package.targets.indices {
    package.targets[index].swiftSettings = (package.targets[index].swiftSettings ?? []) + swiftSettings
}
