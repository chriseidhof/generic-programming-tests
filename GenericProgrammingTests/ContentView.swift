//

import SwiftUI
import GenericsAlt

let initialSubject = Book(year: 2023, title: "Thinking in SwiftUI", published: true, updates: [
    .init(id: UUID(), text: "My first update", date: .now)
])

extension Data {
    var hexDescription: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}

struct ContentView: View {
    @State var subject: Book = initialSubject
    var body: some View {
        VSplitView {
            TextEditor(text: .constant(subject.pretty))
            TextEditor(text: .constant(subject.data.hexDescription))
            List {
                subject.view
            }
            .listStyle(.automatic)
            Form {
                Book.edit($subject)
            }
//            .onChange(of: subject) {
//                print(difference(initialSubject, subject))
//            }
        }
    }
}

#Preview {
    ContentView()
}
