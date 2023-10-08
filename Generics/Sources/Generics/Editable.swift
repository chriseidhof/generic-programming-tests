import Foundation
import SwiftUI

// Generate an editor
public protocol Editable {
    associatedtype E: View

    @ViewBuilder
    static func edit(label: String?, _ binding: Binding<Self>) -> E
}

extension String: Editable {
    public static func edit(label: String?, _ binding: Binding<String>) -> some View {
        TextField(label ?? "", text: binding)
    }
}

extension Int: Editable {
    public static func edit(label: String?, _ binding: Binding<Int>) -> some View {
        TextField(label ?? "", value: binding, format: .number)
    }
}

extension Prod: Editable where Head: Editable, Tail: Editable {
    public static func edit(label: String?, _ binding: Binding<Self>) -> some View {
        Head.edit(label: nil, binding.head)
        Tail.edit(label: nil, binding.tail)
    }
}

extension Struct: Editable where Children: Editable {
    public static func edit(label: String?, _ binding: Binding<Self>) -> some View {
        Children.edit(label: binding.wrappedValue.name, binding.children)
    }
}

extension Tail: Editable {
    public static func edit(label: String?, _ binding: Binding<Tail>) -> some View {
        EmptyView()
    }
}

extension Field: Editable where Value: Editable {
    public static func edit(label: String?, _ binding: Binding<Field<Value>>) -> some View {
        Value.edit(label: binding.wrappedValue.name, binding.value)
    }
}

extension Sum: Editable where Left: Editable, Right: Editable {
    public static func edit(label: String?, _ binding: Binding<Self>) -> some View {
        switch binding.wrappedValue {
        case .left(let label, let l):
            Left.edit(label: nil, .init(get: { l }, set: { binding.wrappedValue = .left(label: label, $0) }))
        case .right(let label, let r):
            Right.edit(label: nil, .init(get: { r }, set: { binding.wrappedValue = .right(label: label, $0) }))
        }
    }
}

public func edit<P: Generic>(_ binding: Binding<P>) -> some View where P.Rep: Editable {
    return P.Rep.edit(label: nil, binding.representation)
}
