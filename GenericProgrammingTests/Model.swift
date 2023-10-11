import Foundation
import GenericsAlt

@GenericAltM
struct Book: Hashable, Generic {
    var year: Int
    var title: String
    var published: Bool
    var updates: [Update]
}

@GenericAltM
struct Update: Hashable, Generic, Identifiable {
    var id: UUID
    var text: String
    var date: Date
}

extension Update: Pretty, Binary, PrettyView, Editor {
}
