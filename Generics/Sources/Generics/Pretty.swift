import Foundation

// Generating plain text
public protocol Pretty {
    func lines() -> [String]
}

extension Pretty {
    public var pretty: String {
        lines().joined(separator: "\n")
    }
}

extension Int: Pretty {
    public func lines() -> [String] {
        ["\(self)"]
    }
}

extension String: Pretty {
    public func lines() -> [String] {
        ["\(self)"]
    }
}

extension Bool: Pretty {
    public func lines() -> [String] {
        [self ? "true" : "false"]
    }
}

extension Field: Pretty where Value: Pretty {
    public func lines() -> [String] {
        ["\(name): \(value.pretty)"]
    }
}

extension Prod: Pretty where Head: Pretty, Tail: Pretty {
    public func lines() -> [String] {
        head.lines() + tail.lines()
    }
}

extension Tail: Pretty {
    public func lines() -> [String] {
        []
    }
}

extension Struct: Pretty where Children: Pretty {
    public func lines() -> [String] {
        ["Person {"] +
        children.lines().map { "    " + $0 } +
        ["}"]

    }
}
