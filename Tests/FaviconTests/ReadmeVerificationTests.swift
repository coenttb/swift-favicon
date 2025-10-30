import Testing
import Favicon
import Foundation
import URLRouting
import Dependencies

@Suite("README Verification")
struct ReadmeVerificationTests {

    @Test("Example from README line 35-52: Creating a Favicon Instance")
    func exampleCreatingFaviconInstance() throws {
        // Example from README
        let icoData = Data("test".utf8)
        let svgData = Data("svg".utf8)
        let png16Data = Data("16".utf8)
        let png32Data = Data("32".utf8)
        let png192Data = Data("192".utf8)
        let appleTouchIconData = Data("apple".utf8)

        // Create an icon set with your favicon data
        let icons = Favicon.IconSet(
            ico: icoData,
            svg: svgData,
            png16: png16Data,
            png32: png32Data,
            png192: png192Data,
            appleTouchIcon: appleTouchIconData
        )

        // Create the favicon instance
        let favicon = Favicon(
            router: Favicon.Route.Router(),
            icons: icons
        )

        // Verify it was created correctly
        #expect(favicon.data(for: .favicon) == icoData)
        #expect(favicon.data(for: .icon(.svg)) == svgData)
    }

    @Test("Example from README line 57-65: Serving Favicons")
    func exampleServingFavicons() throws {
        let icoData = Data("favicon".utf8)
        let icons = Favicon.IconSet(ico: icoData)
        let favicon = Favicon(router: Favicon.Route.Router(), icons: icons)

        // Parse incoming request path
        let route = try favicon.router.parse(URLRequestData(path: "favicon.ico"))

        // Get data and content type for the route
        if let data = favicon.data(for: route) {
            let contentType = favicon.contentType(for: route)
            // Return HTTP response with data and content type
            #expect(data == icoData)
            #expect(contentType == "image/x-icon")
        } else {
            Issue.record("Expected data for favicon route")
        }
    }

    @Test("Example from README line 106-113: Custom Base URL")
    func exampleCustomBaseURL() throws {
        let icons = Favicon.IconSet()

        let router = Favicon.Route.Router()
            .baseURL("https://cdn.example.com/assets")

        let favicon = Favicon(
            router: router,
            icons: icons
        )

        // Verify the router can generate URLs
        let url = favicon.router.url(for: .favicon)
        #expect(url.absoluteString == "https://cdn.example.com/assets/favicon.ico")
    }

    @Test("README Supported Routes are parseable")
    func readmeSupportedRoutes() throws {
        let router = Favicon.Route.Router()

        // Test all routes documented in README
        let faviconRoute = try router.parse(URLRequestData(path: "favicon.ico"))
        #expect(faviconRoute == .favicon)

        let svgRoute = try router.parse(URLRequestData(path: "icon.svg"))
        #expect(svgRoute == .icon(.svg))

        let png16Route = try router.parse(URLRequestData(path: "icon-16x16.png"))
        #expect(png16Route == .icon(.png(.`16`)))

        let png32Route = try router.parse(URLRequestData(path: "icon-32x32.png"))
        #expect(png32Route == .icon(.png(.`32`)))

        let png180Route = try router.parse(URLRequestData(path: "icon-180x180.png"))
        #expect(png180Route == .icon(.png(.`180`)))

        let png192Route = try router.parse(URLRequestData(path: "icon-192x192.png"))
        #expect(png192Route == .icon(.png(.`192`)))

        let png512Route = try router.parse(URLRequestData(path: "icon-512x512.png"))
        #expect(png512Route == .icon(.png(.`512`)))

        let appleTouchIconRoute = try router.parse(URLRequestData(path: "apple-touch-icon.png"))
        #expect(appleTouchIconRoute == .appleTouchIcon(size: nil))

        let appleTouchIcon180Route = try router.parse(URLRequestData(path: "apple-touch-icon-180x180.png"))
        #expect(appleTouchIcon180Route == .appleTouchIcon(size: .`180`))

        let appleTouchIconPrecomposedRoute = try router.parse(URLRequestData(path: "apple-touch-icon-precomposed.png"))
        #expect(appleTouchIconPrecomposedRoute == .appleTouchIconPrecomposed)
    }

    @Test("README data and content type functionality")
    func readmeDataAndContentType() {
        let icons = Favicon.IconSet(
            ico: Data("ico".utf8),
            svg: Data("svg".utf8),
            png16: Data("16".utf8),
            appleTouchIcon: Data("apple".utf8)
        )

        let favicon = Favicon(router: Favicon.Route.Router(), icons: icons)

        // Test data retrieval
        #expect(favicon.data(for: .favicon) == Data("ico".utf8))
        #expect(favicon.data(for: .icon(.svg)) == Data("svg".utf8))
        #expect(favicon.data(for: .icon(.png(.`16`))) == Data("16".utf8))
        #expect(favicon.data(for: .appleTouchIcon(size: nil)) == Data("apple".utf8))

        // Test content types
        #expect(favicon.contentType(for: .favicon) == "image/x-icon")
        #expect(favicon.contentType(for: .icon(.svg)) == "image/svg+xml")
        #expect(favicon.contentType(for: .icon(.png(.`16`))) == "image/png")
        #expect(favicon.contentType(for: .appleTouchIcon(size: nil)) == "image/png")
    }
}
