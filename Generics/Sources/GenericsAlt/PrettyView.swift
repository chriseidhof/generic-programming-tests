import Foundation
import SwiftUI

public protocol PrettyView {
    associatedtype V: View
    var view: V { get }
}

public protocol GPrettyView: Representation {
    associatedtype V: View
    @ViewBuilder
    func view(_ value: Structure) -> V
}

extension Date: PrettyView {
    public var view: some View {
        Text(self, style: .date)
    }
}

extension Int: PrettyView {
    public var view: some View {
        Text("\(self)")
    }
}

extension String: PrettyView {
    public var view: some View {
        Text(self)
    }
}

extension Bool: PrettyView {
    public var view: some View {
        Text(self ? "true" : "false")
    }
}

extension UUID: PrettyView {
    public var view: some View {
        Text("\(self)")
    }
}

extension Array: PrettyView where Element: PrettyView & Identifiable {
    public var view: some View {
        VStack {
            ForEach(self) { el in
                el.view
            }
        }
    }
}

extension Field: GPrettyView where Child: PrettyView {
    public func view(_ value: Child) -> some View {
        LabeledContent(name) {
            value.view
        }
    }
}

extension Struct: GPrettyView where Children: GPrettyView {
    public func view(_ value: Children.Structure) -> some View {
        VStack {
            children.view(value)
        }
    }
}

extension Prod: GPrettyView where Head: GPrettyView, Tail: GPrettyView {
    public func view(_ value: (Head.Structure, Tail.Structure)) -> some View {
        head.view(value.0)
        tail.view(value.1)
    }
}

extension Tail: GPrettyView {
    public func view(_ value: ()) -> some View {
        EmptyView()
    }
}

extension Generic where Repr: GPrettyView {
    public var view: some View {
        Self.representation.view(to)
    }
}
