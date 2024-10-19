// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkService",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "NetworkService", targets: ["NetworkService"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.1")
    ],
    targets: [
        .target(
            name: "NetworkService",
            dependencies: [.product(name: "Alamofire", package: "Alamofire")]
        )
    ]
)
