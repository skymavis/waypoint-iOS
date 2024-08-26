import PackageDescription

let package = Package(
    name: "waypoint",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "waypoint",
            targets: ["id"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "waypoint"),
        .testTarget(
            name: "waypoint-packageTests",
            dependencies: ["waypoint"]),
    ]
)
