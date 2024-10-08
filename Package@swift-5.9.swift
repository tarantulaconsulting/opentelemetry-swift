// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "opentelemetry-swift",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [

         // static libraries
        .library(name: "OpenTelemetryApi", type: .static, targets: ["OpenTelemetryApi"]),
        .library(name: "OpenTelemetryConcurrency", type: .static, targets: ["OpenTelemetryConcurrency"]),
        .library(name: "OpenTelemetrySdk", type: .static, targets: ["OpenTelemetrySdk"]),
        .library(name: "SwiftMetricsShim", type: .static, targets: ["SwiftMetricsShim"]),
        .library(name: "StdoutExporter", type: .static, targets: ["StdoutExporter"]),
        .library(name: "PrometheusExporter", type: .static, targets: ["PrometheusExporter"]),
        .library(name: "OpenTelemetryProtocolExporter", type: .static, targets: ["OpenTelemetryProtocolExporterGrpc"]),
        .library(name: "OpenTelemetryProtocolExporterHTTP", type: .static, targets: ["OpenTelemetryProtocolExporterHttp"]),
        .library(name: "PersistenceExporter", type: .static, targets: ["PersistenceExporter"]),
        .library(name: "InMemoryExporter", type: .static, targets: ["InMemoryExporter"]),
        .library(name: "OTelSwiftLog", type: .static, targets: ["OTelSwiftLog"]),

        // dynamic libraries
        .library(name: "OpenTelemetryApiDynamic", type: .dynamic, targets: ["OpenTelemetryApi"]),
        .library(name: "OpenTelemetryConcurrencyDynamic", type: .dynamic, targets: ["OpenTelemetryConcurrency"]),
        .library(name: "OpenTelemetrySdkDynamic", type: .dynamic, targets: ["OpenTelemetrySdk"]),
        .library(name: "SwiftMetricsShimDynamic", type: .dynamic, targets: ["SwiftMetricsShim"]),
        .library(name: "StdoutExporterDynamic", type: .dynamic, targets: ["StdoutExporter"]),
        .library(name: "PrometheusExporterDynamic", type: .dynamic, targets: ["PrometheusExporter"]),
        .library(name: "OpenTelemetryProtocolExporterDynamic", type: .dynamic, targets: ["OpenTelemetryProtocolExporterGrpc"]),
        .library(name: "OpenTelemetryProtocolExporterHTTPDynamic", type: .dynamic, targets: ["OpenTelemetryProtocolExporterHttp"]),
        .library(name: "PersistenceExporterDynamic", type: .dynamic, targets: ["PersistenceExporter"]),
        .library(name: "InMemoryExporterDynamic", type: .dynamic, targets: ["InMemoryExporter"]),
        .library(name: "OTelSwiftLogDynamic", type: .dynamic, targets: ["OTelSwiftLog"]),

        // executables
        .executable(name: "ConcurrencyContext", targets: ["ConcurrencyContext"]),
        .executable(name: "loggingTracer", targets: ["LoggingTracer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.20.2"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.4"),
        .package(url: "https://github.com/apple/swift-metrics.git", from: "2.1.1"),
    ],
    targets: [
        .target(name: "OpenTelemetryApi",
                dependencies: []),
        .target(name: "OpenTelemetrySdk",
                dependencies: ["OpenTelemetryApi"].withAtomicsIfNeeded()),
        .target(name: "OpenTelemetryConcurrency",
                dependencies: ["OpenTelemetryApi"]),
        .target(name: "OpenTelemetryTestUtils",
                dependencies: ["OpenTelemetryApi", "OpenTelemetrySdk"]),
        .target(name: "OTelSwiftLog",
                dependencies: ["OpenTelemetryApi",
                               .product(name: "Logging", package: "swift-log")],
                path: "Sources/Bridges/OTelSwiftLog"),
        .target(name: "SwiftMetricsShim",
                dependencies: ["OpenTelemetrySdk",
                               .product(name: "CoreMetrics", package: "swift-metrics")],
                path: "Sources/Importers/SwiftMetricsShim",
                exclude: ["README.md"]),
        .target(name: "PrometheusExporter",
                dependencies: ["OpenTelemetrySdk",
                               .product(name: "NIO", package: "swift-nio"),
                               .product(name: "NIOHTTP1", package: "swift-nio")],
                path: "Sources/Exporters/Prometheus"),
        .target(name: "OpenTelemetryProtocolExporterCommon",
                dependencies: ["OpenTelemetrySdk",
                               .product(name: "Logging", package: "swift-log"),
                               .product(name: "SwiftProtobuf", package: "swift-protobuf")],
                path: "Sources/Exporters/OpenTelemetryProtocolCommon"),
        .target(name: "OpenTelemetryProtocolExporterHttp",
                dependencies: ["OpenTelemetrySdk",
                               "OpenTelemetryProtocolExporterCommon"],
                path: "Sources/Exporters/OpenTelemetryProtocolHttp"),
        .target(name: "OpenTelemetryProtocolExporterGrpc",
                dependencies: ["OpenTelemetrySdk",
                               "OpenTelemetryProtocolExporterCommon",
                               .product(name: "GRPC", package: "grpc-swift")],
                path: "Sources/Exporters/OpenTelemetryProtocolGrpc"),
        .target(name: "StdoutExporter",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Exporters/Stdout"),
        .target(name: "InMemoryExporter",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Exporters/InMemory"),
        .target(name: "PersistenceExporter",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Exporters/Persistence"),
        .testTarget(name: "OTelSwiftLogTests",
                    dependencies: ["OTelSwiftLog"],
                    path: "Tests/BridgesTests/OTelSwiftLog"),
        .testTarget(name: "OpenTelemetryApiTests",
                    dependencies: ["OpenTelemetryApi", "OpenTelemetryTestUtils"],
                    path: "Tests/OpenTelemetryApiTests"),
        .testTarget(name: "OpenTelemetrySdkTests",
                    dependencies: ["OpenTelemetrySdk",
                                   "OpenTelemetryConcurrency",
                                   "OpenTelemetryTestUtils"],
                    path: "Tests/OpenTelemetrySdkTests"),
        .testTarget(name: "SwiftMetricsShimTests",
                    dependencies: ["SwiftMetricsShim",
                                   "OpenTelemetrySdk"],
                    path: "Tests/ImportersTests/SwiftMetricsShim"),
        .testTarget(name: "PrometheusExporterTests",
                    dependencies: ["PrometheusExporter"],
                    path: "Tests/ExportersTests/Prometheus"),
        .testTarget(name: "OpenTelemetryProtocolExporterTests",
                    dependencies: ["OpenTelemetryProtocolExporterGrpc",
                                   "OpenTelemetryProtocolExporterHttp",
                                   .product(name: "NIO", package: "swift-nio"),
                                   .product(name: "NIOHTTP1", package: "swift-nio"),
                                   .product(name: "NIOTestUtils", package: "swift-nio")],
                    path: "Tests/ExportersTests/OpenTelemetryProtocol"),
        .testTarget(name: "InMemoryExporterTests",
                    dependencies: ["InMemoryExporter"],
                    path: "Tests/ExportersTests/InMemory"),
        .testTarget(name: "PersistenceExporterTests",
                    dependencies: ["PersistenceExporter"],
                    path: "Tests/ExportersTests/PersistenceExporter"),
        .executableTarget(
            name: "LoggingTracer",
            dependencies: ["OpenTelemetryApi"],
            path: "Examples/Logging Tracer"
        ),
        .executableTarget(
            name: "LogsSample",
            dependencies: ["OpenTelemetrySdk", "OpenTelemetryProtocolExporterGrpc", .product(name: "GRPC", package: "grpc-swift")],
            path: "Examples/Logs Sample"),
        .executableTarget(
            name: "ConcurrencyContext",
            dependencies: ["OpenTelemetrySdk", "OpenTelemetryConcurrency", "StdoutExporter"],
            path: "Examples/ConcurrencyContext"
        ),
    ]
).addPlatformSpecific()

extension [Target.Dependency] {
    func withAtomicsIfNeeded() -> [Target.Dependency] {
        #if canImport(Darwin)
            return self
        #else
            var dependencies = self
            dependencies.append(.product(name: "Atomics", package: "swift-atomics"))
            return dependencies
        #endif
    }
}

extension Package {
    func addPlatformSpecific() -> Self {
        #if !canImport(Darwin)
            dependencies.append(
                .package(url: "https://github.com/apple/swift-atomics.git", .upToNextMajor(from: "1.2.0"))
            )
        #endif
        #if canImport(ObjectiveC)
            dependencies.append(
                .package(url: "https://github.com/undefinedlabs/opentracing-objc", from: "0.5.2")
            )
            products.append(contentsOf: [

                // static libraries
                .library(name: "OpenTracingShim-experimental", targets: ["OpenTracingShim"]),

                // dynamic libraries
                .library(name: "OpenTracingShim-experimentalDynamic", type: .dynamic, targets: ["OpenTracingShim"]),
            ])
            targets.append(contentsOf: [
                .target(name: "OpenTracingShim",
                        dependencies: [
                            "OpenTelemetrySdk",
                            .product(name: "Opentracing", package: "opentracing-objc"),
                        ],
                        path: "Sources/Importers/OpenTracingShim",
                        exclude: ["README.md"]),
                .testTarget(name: "OpenTracingShimTests",
                            dependencies: ["OpenTracingShim",
                                           "OpenTelemetrySdk"],
                            path: "Tests/ImportersTests/OpenTracingShim"),
            ])
        #endif

        #if canImport(Darwin)
            dependencies.append(
                .package(url: "https://github.com/undefinedlabs/Thrift-Swift", from: "1.1.1")
            )
            products.append(contentsOf: [

                // static libraries
                .library(name: "DatadogExporter", targets: ["DatadogExporter"]),
                .library(name: "JaegerExporter", targets: ["JaegerExporter"]),
                .library(name: "NetworkStatus", targets: ["NetworkStatus"]),
                .library(name: "ResourceExtension", targets: ["ResourceExtension"]),
                .library(name: "SignPostIntegration", targets: ["SignPostIntegration"]),
                .library(name: "URLSessionInstrumentation", targets: ["URLSessionInstrumentation"]),
                .library(name: "ZipkinExporter", targets: ["ZipkinExporter"]),

                // dynamic libraries
                .library(name: "DatadogExporterDynamic", type: .dynamic, targets: ["DatadogExporter"]),
                .library(name: "JaegerExporterDynamic", type: .dynamic, targets: ["JaegerExporter"]),
                .library(name: "NetworkStatusDynamic", type: .dynamic, targets: ["NetworkStatus"]),
                .library(name: "ResourceExtensionDynamic", type: .dynamic, targets: ["ResourceExtension"]),
                .library(name: "SignPostIntegrationDynamic", type: .dynamic, targets: ["SignPostIntegration"]),
                .library(name: "URLSessionInstrumentationDynamic", type: .dynamic, targets: ["URLSessionInstrumentation"]),
                .library(name: "ZipkinExporterDynamic", type: .dynamic, targets: ["ZipkinExporter"]),

                // executables
                .executable(name: "OTLPExporter", targets: ["OTLPExporter"]),
                .executable(name: "OTLPHTTPExporter", targets: ["OTLPHTTPExporter"]),
                .executable(name: "simpleExporter", targets: ["SimpleExporter"]),
            ])
            targets.append(contentsOf: [
                .target(name: "JaegerExporter",
                        dependencies: [
                            "OpenTelemetrySdk",
                            .product(name: "Thrift", package: "Thrift-Swift", condition: .when(platforms: [.iOS, .macOS, .tvOS, .macCatalyst, .linux])),
                        ],
                        path: "Sources/Exporters/Jaeger"),
                .testTarget(name: "JaegerExporterTests",
                            dependencies: ["JaegerExporter"],
                            path: "Tests/ExportersTests/Jaeger"),
                .executableTarget(
                    name: "SimpleExporter",
                    dependencies: ["OpenTelemetrySdk", "JaegerExporter", "StdoutExporter", "ZipkinExporter", "ResourceExtension", "SignPostIntegration"],
                    path: "Examples/Simple Exporter",
                    exclude: ["README.md"]
                ),
                .target(name: "NetworkStatus",
                        dependencies: [
                            "OpenTelemetryApi",
                        ],
                        path: "Sources/Instrumentation/NetworkStatus",
                        linkerSettings: [.linkedFramework("CoreTelephony", .when(platforms: [.iOS]))]),
                .testTarget(name: "NetworkStatusTests",
                            dependencies: [
                                "NetworkStatus",
                            ],
                            path: "Tests/InstrumentationTests/NetworkStatusTests"),
                .target(name: "URLSessionInstrumentation",
                        dependencies: ["OpenTelemetrySdk", "NetworkStatus"],
                        path: "Sources/Instrumentation/URLSession",
                        exclude: ["README.md"]),
                .testTarget(name: "URLSessionInstrumentationTests",
                            dependencies: ["URLSessionInstrumentation",
                                           .product(name: "NIO", package: "swift-nio"),
                                           .product(name: "NIOHTTP1", package: "swift-nio")],
                            path: "Tests/InstrumentationTests/URLSessionTests"),
                .executableTarget(
                    name: "NetworkSample",
                    dependencies: ["URLSessionInstrumentation", "StdoutExporter"],
                    path: "Examples/Network Sample",
                    exclude: ["README.md"]
                ),
                .target(name: "ZipkinExporter",
                        dependencies: ["OpenTelemetrySdk"],
                        path: "Sources/Exporters/Zipkin"),
                .testTarget(name: "ZipkinExporterTests",
                            dependencies: ["ZipkinExporter"],
                            path: "Tests/ExportersTests/Zipkin"),
                .executableTarget(
                    name: "OTLPExporter",
                    dependencies: ["OpenTelemetrySdk", "OpenTelemetryProtocolExporterGrpc", "StdoutExporter", "ZipkinExporter", "ResourceExtension", "SignPostIntegration"],
                    path: "Examples/OTLP Exporter",
                    exclude: ["README.md"]
                ),
                .executableTarget(
                    name: "OTLPHTTPExporter",
                    dependencies: ["OpenTelemetrySdk", "OpenTelemetryProtocolExporterHttp", "StdoutExporter", "ZipkinExporter", "ResourceExtension", "SignPostIntegration"],
                    path: "Examples/OTLP HTTP Exporter",
                    exclude: ["README.md"]
                ),
                .target(name: "SignPostIntegration",
                        dependencies: ["OpenTelemetrySdk"],
                        path: "Sources/Instrumentation/SignPostIntegration",
                        exclude: ["README.md"]),
                .target(name: "ResourceExtension",
                        dependencies: ["OpenTelemetrySdk"],
                        path: "Sources/Instrumentation/SDKResourceExtension",
                        exclude: ["README.md"]),
                .testTarget(name: "ResourceExtensionTests",
                            dependencies: ["ResourceExtension", "OpenTelemetrySdk"],
                            path: "Tests/InstrumentationTests/SDKResourceExtensionTests"),
                .target(name: "DatadogExporter",
                        dependencies: ["OpenTelemetrySdk"],
                        path: "Sources/Exporters/DatadogExporter",
                        exclude: ["NOTICE", "README.md"]),
                .testTarget(name: "DatadogExporterTests",
                            dependencies: ["DatadogExporter",
                                           .product(name: "NIO", package: "swift-nio"),
                                           .product(name: "NIOHTTP1", package: "swift-nio")],
                            path: "Tests/ExportersTests/DatadogExporter"),
                .executableTarget(
                    name: "DatadogSample",
                    dependencies: ["DatadogExporter"],
                    path: "Examples/Datadog Sample",
                    exclude: ["README.md"]
                ),
                .executableTarget(
                    name: "PrometheusSample",
                    dependencies: ["OpenTelemetrySdk", "PrometheusExporter"],
                    path: "Examples/Prometheus Sample",
                    exclude: ["README.md"]
                ),
            ])
        #endif

        return self
    }
}
