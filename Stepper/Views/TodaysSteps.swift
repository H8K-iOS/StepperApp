import SwiftUI

struct TodaysSteps: View {
    let step: StepModel
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text("\(step.count)")
                    .font(.system(size: 34, weight: .bold).monospaced())
                Text("Steps today")
                    .font(.system(size: 14, weight: .medium).monospaced())
                
                HStack() {
                    Text("⚡︎")
                        .font(.system(size: 22))
                    Text("173 days streak")
                        .font(.system(size: 14, weight: .medium).monospaced())
                    
                    Spacer()
                }
                .padding(5)
                .frame(maxWidth: .infinity)
                .border(.green.gradient, width: 4)
            }
            .padding([.horizontal, .bottom], 4)
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.leading, 6)
        .foregroundStyle(.green.gradient)
        .frame(maxWidth: .infinity)
        .background(.black)
        .border(.green, width: 3)
        .shadow(color: .white, radius: 1)
    }
}

#Preview {
    ContentView()
        .environmentObject(MainViewModel())
}




