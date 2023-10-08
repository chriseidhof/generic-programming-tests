import Generics

struct Person: Hashable {
    var age: Int
    var name: String
}

extension Person: Generic {
    // todo macro
    typealias Rep = Struct<Prod<Label<Int>, Prod<Label<String>, Tail>>>

    // todo macro
    init(_ rep: Rep) {
        age = rep.children.head.value
        name = rep.children.tail.head.value
    }

    // todo macro
    var rep: Rep {
        .init(name: "Person", children: .init(head: .init(name: "age", value: age), tail: .init(head: .init(name: "name", value: name), tail: Tail())))
    }
}

enum PersonOrCompany: Hashable {
    case person(Person)
    case company(name: String)
}

extension PersonOrCompany: Generic {
    // todo macro
    typealias Rep = Sum<Person.Rep, Label<String>>

    // todo macro
    init(_ rep: Rep) {
        switch rep {
        case let .left(_, l): self = .person(.init(l))
        case let .right(_, r): self = .company(name: .init(r.value))
        }
    }

    // todo macro
    var rep: Rep {
        switch self {
        case .person(let p): .left(label: "person", p.rep)
        case .company(name: let n): .right(label: "company", .init(name: "name", value: n))
        }
    }
}
