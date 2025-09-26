import Favicon
import Foundation
import Dependencies

// Example 1: Basic usage with minimal configuration
let basicFavicon = Favicon(
    router: Favicon.Route.Router(),
    customSet: Favicon.Set(
        ico: Favicon.Icon.ICO(data: Data("favicon".utf8))
    )
)

// Example 2: Complete configuration with all features
let completeFavicon = Favicon(
    router: Favicon.Route.Router()
        .baseURL("https://cdn.example.com/assets"),
    configuration: Favicon.Configuration(
        includeAppleTouchIcon: true,
        colorScheme: Favicon.Configuration.ColorScheme(
            primary: "#2196f3",
            background: "#ffffff"
        )
    ),
    customSet: Favicon.Set(
        ico: Favicon.Icon.ICO(data: Data()),
        png: Favicon.Icon.PNG(
            data16: Data("16x16".utf8),
            data32: Data("32x32".utf8),
            data192: Data("192x192".utf8)
        ),
        svg: Favicon.Icon.SVG(data: Data("<svg></svg>".utf8)),
        appleTouchIcon: Favicon.Icon.AppleTouchIcon(
            standard: Data("apple-touch-icon".utf8)
        )
    )
)

// Example 3: Using with HTML generation and dependency injection
withDependencies {
    $0.favicon = completeFavicon
} operation: {
    // The Favicon.Head will use the favicon from dependencies
    let head = Favicon.Head()

    // This would normally be part of your HTML template
    print("HTML head elements would include:")
    // head.body would generate the appropriate link and meta tags
}

// Example 4: Serving favicon data
if let faviconData = completeFavicon.data(for: .favicon) {
    let contentType = completeFavicon.contentType(for: .favicon)
    print("Serving favicon.ico with content type: \(contentType)")
    print("Data size: \(faviconData.count) bytes")
}

// Example 5: Working with different routes
let routes: [Favicon.Route] = [
    .favicon,
    .appleTouchIcon(),
    .icon(.svg),
    .icon(.png(Favicon.Icon.Size(width: 16, height: 16))),
    .icon(.png(Favicon.Icon.Size(width: 32, height: 32)))
]

for route in routes {
    if let data = completeFavicon.data(for: route) {
        let contentType = completeFavicon.contentType(for: route)
        print("Route available: \(route) -> \(contentType)")
    }
}