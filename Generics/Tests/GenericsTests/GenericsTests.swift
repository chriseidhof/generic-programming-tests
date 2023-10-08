import XCTest
import Generics

// todo conform to Generic protocol
@GenericM
struct Person: Hashable, Generic {
    var age: Int
    var name: String
    var deleted: Bool
}

let p = Person(age: 27, name: "test", deleted: false)

final class GenericsTests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(Person.from(p.rep), p)
    }

    func testPretty() throws {
        XCTAssertEqual(p.rep.pretty, """
        Person {
            age: 27
            name: test
            deleted: false
        }
        """)
    }
}
