import Foundation
import SwiftUI

// Generate a SwiftUI view
public protocol PrettyView {
    associatedtype V: View

    @ViewBuilder
    var view: V { get }
}

extension Struct: PrettyView where Children: PrettyView {
    public var view: some View {
        VStack {
            Text(name).bold()
            children.view
        }
    }
}

extension Prod: PrettyView where Head: PrettyView, Tail: PrettyView {
    @ViewBuilder
    public var view: some View {
        head.view
        tail.view
    }
}

extension Label: PrettyView where A: PrettyView {
    public var view: some View {
        LabeledContent(content: {
            value.view
        }, label: {
            Text(name)
        })
    }
}

extension Tail: PrettyView {
    public var view: EmptyView { EmptyView() }
}

extension Int: PrettyView {
    public var view: some View { Text("\(self)") }
}

extension String: PrettyView {
    public var view: some View { Text("\(self)") }
}

extension Sum: PrettyView where Left: PrettyView, Right: PrettyView {
    public var view: some View {
        switch self {
        case .left(_, let l):
            l.view
        case .right(_, let r):
            r.view
        }
    }
}
