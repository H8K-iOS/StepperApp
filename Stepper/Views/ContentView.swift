import SwiftUI

struct ContentView: View {
    @State private var healthStore = HealtStore()
    
    var body: some View {
        VStack {
            List(healthStore.steps) { step in
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(isUnder10k(step.count) ? .red : .green)
                    Text("\(step.count)")
                    Spacer()
                    Text(step.date.formatted(date: .abbreviated, time: .omitted))
                }
            }
        }.task {
            await healthStore.requestAuth()
            do {
                try await healthStore.getSteps()
            } catch {
                print(error)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
