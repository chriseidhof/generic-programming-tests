import Foundation

extension Pretty {
    public var pretty: String {
        lines().joined(separator: "\n")
    }
}

public protocol Pretty {
    func lines() -> [String]
}

public protocol GPretty: Representation {
    func lines(_ value: Structure) -> [String]
}

extension Int: Pretty {
    public func lines() -> [String] {
        ["\(self)"]
    }
}

extension Array: Pretty where Element: Pretty {
    public func lines() -> [String] {
        ["["] +
        self.map { el in
            el.lines().map { "    " + $0 }
        }.joined(separator: [","]) +
        ["]"]
    }
}

extension UUID: Pretty {
    public func lines() -> [String] {
        [uuidString]
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

extension Date: Pretty {
    public func lines() -> [String] {
        [formatted()]
    }
}


extension Field: GPretty where Child: Pretty {
    public func lines(_ value: Child) -> [String] {
        ["\(name): \(value.pretty)"]
    }
}

extension Struct: GPretty where Children: GPretty {
    public func lines(_ value: Children.Structure) -> [String] {
        ["\(name) {"] +
        children.lines(value).map { "    " + $0 } +
        ["}"]
    }
}

extension Prod: GPretty where Head: GPretty, Tail: GPretty {
    public func lines(_ value: (Head.Structure, Tail.Structure)) -> [String] {
        head.lines(value.0) + tail.lines(value.1)
    }
}

extension Tail: GPretty {
    public func lines(_ value: ()) -> [String] {
        []
    }
}

extension Generic where Repr: GPretty {
    public func lines() -> [String] {
        Self.representation.lines(to)
    }

    public var pretty: String {
       lines().joined(separator: "\n")
    }
}
