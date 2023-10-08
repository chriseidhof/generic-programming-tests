//

import Foundation

@attached(member, names: named(Rep), named(rep), named(from))
//@attached(extension, conformances: Generic)
public macro GenericM() = #externalMacro(module: "GenericsMacros", type: "GenericMacro")


public protocol Generic {
    associatedtype Rep
    static func from(_ rep: Rep) -> Self
    var rep: Rep { get }
    // todo: we could separate the Rep from the value to get maximum performance and be able to reflect without having a value. the rep could possibly be used to get/set the value?
}

extension Generic {
    init(_ rep: Rep) {
        self = .from(rep)
    }
    
    // Helper for bindings
    var representation: Rep {
        get { rep }
        set { self = Self.from(newValue) }
    }
}

public struct Field<Value> {
    public var name: String
    public var value: Value
    public init(name: String, value: Value) {
        self.name = name
        self.value = value
    }
}

public struct Prod<Head, Tail> {
    public var head: Head
    public var tail: Tail
    public init(head: Head, tail: Tail) {
        self.head = head
        self.tail = tail
    }
}

public enum Sum<Left, Right> {
    case left(label: String, Left)
    case right(label: String, Right)
}

public struct Struct<Children> {
    public var name: String
    public var children: Children
    public init(name: String, children: Children) {
        self.name = name
        self.children = children
    }
}

public struct Tail { 
    public init() { }
}


