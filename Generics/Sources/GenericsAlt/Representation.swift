//

import Foundation


public protocol Representation {
    associatedtype Structure
}

public struct Struct<Children: Representation>: Representation {
    public var name: String
    public var children: Children
    public init(name: String, children: Children) {
        self.name = name
        self.children = children
    }

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

public enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

extension Either: Representation where Left: Representation, Right: Representation {
    public typealias Structure = Either<Left.Structure, Right.Structure> // todo?
}

public struct Tail: Representation {
    public typealias Structure = ()

    public init() { }
}

public protocol Generic {
    associatedtype Repr: Representation
    static var representation: Repr { get }
    var to: Repr.Structure { get }
    static func from(_ rep: Repr.Structure) -> Self
}

extension Generic {
    public init(_ structure: Repr.Structure) {
        self = .from(structure)
    }
}

