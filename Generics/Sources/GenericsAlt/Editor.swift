import Foundation
import SwiftUI

public protocol Editor {
    associatedtype E: View
    static func edit(title: LocalizedStringKey, _ binding: Binding<Self>) -> E
}

public protocol GEditor: Representation {
    associatedtype E: View
    @ViewBuilder
    func edit(_ binding: Binding<Structure>) -> E
}

extension Int: Editor {
    public static func edit(title: LocalizedStringKey, _ binding: Binding<Int>) -> some View {
        TextField(title, value: binding, format: .number)
    }
}

extension String: Editor {
    public static func edit(title: LocalizedStringKey, _ binding: Binding<Self>) -> some View {
        TextField(title, text: binding)
    }
}

extension Bool: Editor {
    public static func edit(title: LocalizedStringKey, _ binding: Binding<Bool>) -> some View {
        Toggle(title, isOn: binding)
    }
}


extension Field: GEditor where Child: Editor {
    public func edit(_ binding: Binding<Child>) -> some View {
        Child.edit(title: .init(name), binding)
    }
}

extension Struct: GEditor where Children: GEditor {
    public func edit(_ binding: Binding<Children.Structure>) -> some View {
        children.edit(binding)
    }
}

extension Prod: GEditor where Head: GEditor, Tail: GEditor {
    public func edit(_ binding: Binding<(Head.Structure, Tail.Structure)>) -> some View {
        head.edit(binding.0)
        tail.edit(binding.1)
    }
}

extension Tail: GEditor {
    public func edit(_ binding: Binding<()>) -> some View {
        EmptyView()
    }
}

extension Generic where Repr: GEditor {
    static public func edit(_ value: Binding<Self>) -> some View {
        representation.edit(value.structure)
    }
}

extension Generic {
    var structure: Repr.Structure {
        get { to }
        set { self = .init(newValue)}
    }
}
