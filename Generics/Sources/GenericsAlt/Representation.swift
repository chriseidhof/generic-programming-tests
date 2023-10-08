//

import Foundation

public protocol Representation {
    associatedtype Structure
}

public struct Struct<Children: Representation>: Representation {
    public var name: String
    public var children: Children

    public typealias Structure = Children.Structure
}

public struct Field<Child>: Representation {
    public var name: String

    public typealias Structure = Child // TODO special type for values? K<Child>?

    public init(name: String) {
        self.name = name
    }
}

public struct Prod<Head: Representation, Tail: Representation>: Representation {
    public var head: Head
    public var tail: Tail

    public typealias Structure = (Head.Structure, Tail.Structure) // todo?

    public init(head: Head, tail: Tail) {
        self.head = head
        self.tail = tail
    }
}

//public enum Sum<Left, Right> {
//    case left(label: String, Left)
//    case right(label: String, Right)
//}
//
public struct Tail: Representation {
    public typealias Structure = ()

    public init() { }
}



struct Person {
    var age: Int
    var name: String
}

public protocol Generic {
    associatedtype Repr: Representation
    static var representation: Repr { get }
    init(_ structure: Repr.Structure)
    var to: Repr.Structure { get }
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
