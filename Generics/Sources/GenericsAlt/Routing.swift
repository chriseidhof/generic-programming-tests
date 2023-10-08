protocol ToRoute {
    var components: [String] { get }
}

extension String: ToRoute {
    var components: [String] { [self] }
}

extension Int: ToRoute {
    var components: [String] { ["\(self)"] }
}

protocol GToRoute: Representation {
    func components(_ value: Structure) -> [String]
}

extension Field: GToRoute where Child: ToRoute {
    func components(_ value: Child) -> [String] {
        value.components
    }
}

extension Tail: GToRoute {
    func components(_ value: ()) -> [String] {
        []
    }
}

extension Either: GToRoute where Left: GToRoute, Right: GToRoute {
    func components(_ value: Either<Left.Structure, Right.Structure>) -> [String] {
        fatalError("TODO")
    }
}
