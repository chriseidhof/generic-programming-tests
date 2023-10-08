protocol Empty {
    static var empty: Self { get }
}

extension String: Empty {
    static let empty: String = ""
}

extension Int: Empty {
    static let empty: Int = 0
}

extension Bool: Empty {
    static let empty = false
}

protocol GEmpty: Representation {
    static var empty: Structure { get }
}

extension Tail: GEmpty {
    static let empty: () = ()
}

extension Field: GEmpty where Child: Empty {
    static var empty: Child {
        Child.empty
    }
}

extension Prod: GEmpty where Head: GEmpty, Tail: GEmpty {
    static var empty: (Head.Structure, Tail.Structure) {
        (Head.empty, Tail.empty)
    }
}

extension Struct: GEmpty where Children: GEmpty {
    static var empty: Children.Structure {
        Children.empty
    }
}

extension Generic where Repr: GEmpty {
    static var empty: Self {
        .init(Repr.empty)
    }
}
