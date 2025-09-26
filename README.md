# swift-favicon

Type-safe favicon serving for Swift web applications.

## Overview

swift-favicon provides a clean, type-safe API for serving favicons in Swift web applications. It handles routing, content types, and HTML generation for various favicon formats including ICO, PNG, SVG, and Apple Touch Icons.

## Features

- **Type-safe routing** with bidirectional URL parsing via swift-url-routing
- **Multiple format support**: ICO, PNG (multiple sizes), SVG, Apple Touch Icons
- **HTML generation** for favicon meta tags
- **Dependency injection** support via swift-dependencies
- **Clean domain model** with separation of concerns

## Installation

Add swift-favicon to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-favicon", from: "0.1.0"),
]
```

## Basic Usage

### Creating a Favicon Instance

```swift
import Favicon

// Create an icon set with your favicon data
let icons = Favicon.IconSet(
    ico: icoData,
    svg: svgData,
    png16: png16Data,
    png32: png32Data,
    png192: png192Data,
    png512: png512Data,
    appleTouchIcon: appleTouchIconData
)

// Create the favicon instance
let favicon = Favicon(
    router: Favicon.Route.Router(),
    icons: icons
)
```

### Serving Favicons

```swift
// Parse incoming request path
let route = try favicon.router.parse(URLRequestData(path: "favicon.ico"))

// Get data and content type for the route
if let data = favicon.data(for: route) {
    let contentType = favicon.contentType(for: route)
    // Return HTTP response with data and content type
}
```

### Generating HTML

```swift
import HTML
import Dependencies

// Use with swift-html to generate favicon meta tags
@Dependency(\.favicon) var favicon

let html = HTML {
    Head {
        Favicon.Head()
    }
    Body {
        // Your content
    }
}
```

This generates appropriate `<link>` tags for all available favicon formats.

## Supported Routes

- `/favicon.ico` - Classic favicon format
- `/icon.svg` - Scalable vector favicon
- `/icon-16x16.png` - PNG icon (16x16)
- `/icon-32x32.png` - PNG icon (32x32)
- `/icon-180x180.png` - PNG icon (180x180)
- `/icon-192x192.png` - PNG icon (192x192)
- `/icon-512x512.png` - PNG icon (512x512)
- `/apple-touch-icon.png` - Apple Touch Icon (default)
- `/apple-touch-icon-180x180.png` - Apple Touch Icon (180x180)
- `/apple-touch-icon-precomposed.png` - Precomposed Apple Touch Icon

## Advanced Usage

### Custom Base URL

```swift
let router = Favicon.Route.Router()
    .baseURL("https://cdn.example.com/assets")

let favicon = Favicon(
    router: router,
    icons: icons
)
```

### Configuration Options

```swift
let configuration = Favicon.Configuration(
    includeAppleTouchIcon: true,
    colorScheme: Favicon.Configuration.ColorScheme(
        primary: "#2196f3",
        background: "#1976d2"
    )
)

let favicon = Favicon(
    router: Favicon.Route.Router(),
    icons: icons,
    configuration: configuration
)
```

## Integration Examples

### With Vapor

```swift
import Vapor
import Favicon

func routes(_ app: Application) throws {
    // Setup favicon with your icons
    let favicon = Favicon(
        router: Favicon.Route.Router(),
        icons: loadIcons()
    )

    // Handle favicon routes
    app.get("favicon.ico") { req in
        guard let data = favicon.data(for: .favicon) else {
            throw Abort(.notFound)
        }
        return Response(
            status: .ok,
            headers: ["Content-Type": favicon.contentType(for: .favicon)],
            body: .init(data: data)
        )
    }
}
```

### With Hummingbird

```swift
import Hummingbird
import Favicon

let favicon = Favicon(
    router: Favicon.Route.Router(),
    icons: loadIcons()
)

router.get("favicon.ico") { request in
    guard let data = favicon.data(for: .favicon) else {
        throw HBHTTPError(.notFound)
    }
    return Response(
        status: .ok,
        headers: ["content-type": favicon.contentType(for: .favicon)],
        body: .data(data)
    )
}
```

## License

This package is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.