import XCTest
@testable import GenericsAlt

struct Person: Hashable {
    var age: Int
    var name: String
}

extension Person: Generic {
    static let representation = Struct(name: "Person", children: Prod(head: Field<Int>(name: "age"), tail: Prod(head: Field<String>(name: "name"), tail: Tail())))

    init(_ structure: Prod<Field<Int>, Prod<Field<String>, Tail>>.Structure) {
        age = structure.0
        name = structure.1.0
    }

    var to: Prod<Field<Int>, Prod<Field<String>, Tail>>.Structure {
        (age, (name, ()))
    }
}

let p = Person(age: 27, name: "test")

final class GenericsTests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(Person(p.to), p)
    }

    func testPretty() throws {
        XCTAssertEqual(p.pretty, """
        Person {
            age: 27
            name: test
        }
        """)
    }

    func testEmpty() throws {
        XCTAssertEqual(Person.empty, .init(age: 0, name: ""))
    }
}
