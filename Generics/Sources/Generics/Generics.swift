//

import Foundation

public protocol Generic {
    associatedtype Rep
    init(_ rep: Rep)
    var rep: Rep { get }
    // todo: we could separate the Rep from the value to get maximum performance and be able to reflect without having a value. the rep could possibly be used to get/set the value?
}

extension Generic {
    // Helper for bindings
    var representation: Rep {
        get { rep }
        set { self = .init(newValue) }
    }
}

public struct Label<A> {
    public var name: String
    public var value: A
    public init(name: String, value: A) {
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


