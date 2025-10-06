import SwiftUI

struct ContentView: View {
    @State private var healthStore = HealtStore()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello")
        }.task {
            await healthStore.requestAuth()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
