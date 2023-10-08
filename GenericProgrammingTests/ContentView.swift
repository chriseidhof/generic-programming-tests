//

import SwiftUI
import Generics

let initialSubject: PersonOrCompany = .person( Person(age: 38, name: "Chris"))

struct ContentView: View {
    @State var subject: PersonOrCompany = initialSubject
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            subject.rep.view
            Form {
                edit($subject)
            }
            .onChange(of: subject) {
                print(difference(initialSubject, subject))
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
