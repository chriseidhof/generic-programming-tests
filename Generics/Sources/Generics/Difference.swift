import Foundation

// Generating plain text
public protocol Difference {
    func difference(from other: Self) -> [String]
}

extension Field: Difference where Value: Equatable {
    public func difference(from other: Field<Value>) -> [String] {
        if value == other.value { return [] }
        return ["\(name): \(value) != \(other.value)"]
    }
}


extension Prod: Difference where Head: Difference, Tail: Difference {
    public func difference(from other: Prod<Head, Tail>) -> [String] {
        head.difference(from: other.head) + tail.difference(from: other.tail)
    }
}

extension Tail: Difference {
    public func difference(from other: Tail) -> [String] {
        []
    }
}

extension Sum: Difference where Left: Difference, Right: Difference {
    public func difference(from other: Sum<Left, Right>) -> [String] {
        switch (self, other) {
        case let (.left(_, l), .left(_, r)):
            l.difference(from: r) // todo add label
        case let (.right(_, l), .right(_, r)):
            l.difference(from: r)
        case let (.left(l0, _), .right(l1, _)):
            ["case \(l0) != case \(l1)"]
        case let (.right(l0, _), .left(l1, _)):
            ["case \(l0) != case \(l1)"]
        }
    }
}

extension Struct: Difference where Children: Difference {
    public func difference(from other: Struct<Children>) -> [String] {
        children.difference(from: other.children)
    }
}

public func difference<Value: Generic>(_ l: Value, _ r: Value) -> String where Value.Rep: Difference {
    let lines = l.rep.difference(from: r.rep)
    if lines.isEmpty { return "Same" }
    return lines.joined(separator: "\n")
}
