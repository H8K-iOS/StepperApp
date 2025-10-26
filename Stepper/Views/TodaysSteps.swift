import SwiftUI

struct TodaysSteps: View {
    let step: StepModel
    let stepProgress: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(step.count)")
                    .font(.system(size: 34, weight: .bold).monospaced())
                    .glowEffect(color: .green, radius: 6)
                
                Text("Steps today")
                    .font(.system(size: 14, weight: .medium).monospaced())
                    .glowEffect(color: .green, radius: 6)
                
                StepProgress(progress: stepProgress)
                
                HStack {
                    Text("⚡︎")
                        .font(.system(size: 22))
                    Text("173 days streak")
                        .font(.system(size: 14, weight: .medium).monospaced())
                        .glowEffect(color: .green, radius: 6)
                    
                    Spacer()
                }
                .padding(5)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(.green, lineWidth: 3)
                        .glowEffect(color: .green, radius: 6)
                )
            }
            .padding([.horizontal, .bottom], 5)
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.leading, 6)
        .foregroundStyle(.green)
        .frame(maxWidth: .infinity, maxHeight: 150)
        .background(.black)
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(.green, lineWidth: 3)
                .glowEffect(color: .green, radius: 6)
        )
    }
}

struct StepProgress: View {
    let progress: Int
    let row = 1
    let segmentRow: Int = 7
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...segmentRow, id: \.self) { segment in
                let index = (row - 1) * segmentRow + segment
                let isFill = index <= progress
                
                Rectangle()
                    .frame(maxHeight: 5)
                    .foregroundStyle(isFill ? .green : .gray.opacity(0.4))
                    .glowEffect(color: .green, radius: 3)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MainViewModel())
}




