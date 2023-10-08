import XCTest
@testable import GenericsAlt

@GenericAltM
struct Person: Hashable, Generic {
    var age: Int
    var name: String
    var deleted: Bool
}

let p = Person(age: 27, name: "test", deleted: false)

final class GenericsTests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(Person(p.to), p)
    }

    func testPretty() throws {
        XCTAssertEqual(p.pretty, """
        Person {
            age: 27
            name: test
            deleted: false
        }
        """)
    }

    func testEmpty() throws {
        XCTAssertEqual(Person.empty, .init(age: 0, name: "", deleted: false))
    }
}
