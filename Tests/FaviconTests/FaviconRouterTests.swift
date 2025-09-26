import Testing
import Favicon
import URLRouting
import Foundation
import Dependencies
import DependenciesTestSupport

@Suite(
    "Favicon Router Tests"
)
struct FaviconRouterTests {
    let router = Favicon.Route.Router()

    @Test("Parse favicon.ico route")
    func parseFaviconIco() throws {

        let route = try router.parse(URLRequestData(path: "favicon.ico"))
        #expect(route == .favicon)

        // Test roundtrip
        let path = try router.print(.favicon)
        #expect(path.path.joined(separator: "/") == "favicon.ico")
    }

    @Test("Parse apple-touch-icon routes")
    func parseAppleTouchIcon() throws {

        // Test default apple-touch-icon
        let defaultRoute = try router.parse(URLRequestData(path: "apple-touch-icon.png"))
        #expect(defaultRoute == .appleTouchIcon(size: nil))

        // Test sized apple-touch-icon
        let sizedRoute = try router.parse(URLRequestData(path: "apple-touch-icon-180x180.png"))
        #expect(sizedRoute == .appleTouchIcon(size: .`180`))

        // Test precomposed
        let precomposedRoute = try router.parse(URLRequestData(path: "apple-touch-icon-precomposed.png"))
        #expect(precomposedRoute == .appleTouchIconPrecomposed)
    }

    @Test("Parse PNG icon routes")
    func parsePNGIcons() throws {
        // Test 16x16 PNG
        let png16 = try router.parse(URLRequestData(path: "icon-16x16.png"))
        #expect(png16 == .icon(.png(.`16`)))

        // Test 32x32 PNG
        let png32 = try router.parse(URLRequestData(path: "icon-32x32.png"))
        #expect(png32 == .icon(.png(.`32`)))
    }

    @Test("Parse SVG icon route")
    func parseSVGIcon() throws {
        // Test SVG icon
        let iconSvg = try router.parse(URLRequestData(path: "icon.svg"))
        #expect(iconSvg == .icon(.svg))
    }

    @Test("Print routes")
    func printRoutes() throws {
        // Test printing various routes
        let favicon = try router.print(.favicon)
        #expect(favicon.path.joined(separator: "/") == "favicon.ico")

        let appleTouchIcon = try router.print(.appleTouchIcon())
        #expect(appleTouchIcon.path.joined(separator: "/") == "apple-touch-icon.png")

        let svg = try router.print(.icon(.svg))
        #expect(svg.path.joined(separator: "/") == "icon.svg")

        let png16 = try router.print(.icon(.png(.`16`)))
        #expect(png16.path.joined(separator: "/") == "icon-16x16.png")
    }

    @Test("Invalid routes throw errors")
    func invalidRoutes() {

        #expect(throws: Error.self) {
            try router.parse(URLRequestData(path: "invalid-route.txt"))
        }

        #expect(throws: Error.self) {
            try router.parse(URLRequestData(path: "not-a-favicon"))
        }
    }
}
