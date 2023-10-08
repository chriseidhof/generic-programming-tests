//

import Foundation

protocol EmptyValue {
    static var emptyValue: Self { get }
}

extension Int: EmptyValue {
    static var emptyValue: Int { 0 }
}

extension String: EmptyValue {
    static var emptyValue: String { "" }
}

extension Label: EmptyValue where A: EmptyValue {
    static var emptyValue: Self { .init(name: "", value: .emptyValue) }
}


extension Prod: EmptyValue where Head: EmptyValue, Tail: EmptyValue {
    static var emptyValue: Prod<Head, Tail> {
        .init(head: .emptyValue, tail: .emptyValue)
    }
}

extension Tail: EmptyValue {
    static let emptyValue = Self()
}

extension Struct: EmptyValue where Children: EmptyValue {
    static var emptyValue: Struct<Children> {
        Struct(name: "", children: .emptyValue)
    }
}
