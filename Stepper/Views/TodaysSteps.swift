import SwiftUI

struct TodaysSteps: View {
    let step: StepModel
    let goal: Int
    let stepProgress: Int
    let activeStreak: Int?
    let previusStreak: Int?
    
    var body: some View {
        //TODO: - UI
        /// Refactor
        /// Adaptive UI
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(step.count)")
                    .font(.system(size: 34, weight: .bold).monospaced())
                    .glowEffect(color: .green, radius: 6)
                
                Text("Steps today")
                    .font(.system(size: 14, weight: .medium).monospaced())
                    .glowEffect(color: .green, radius: 6)
                
                StepProgress(currentSteps: step.count, goal: goal)
                
                HStack {
                    
                    if let prev = previusStreak, (activeStreak == 0) {
                        Text("⚡︎")
                            .font(.system(size: 22))
                            .foregroundStyle(.red)
                            .blinkAnimation()
                        Text("\(prev) day streak at risk!")
                            .font(.system(size: 14, weight: .medium).monospaced())
                            .foregroundStyle(.red)
                            .glowEffect(color: .red, radius: 6)
                            .blinkAnimation()
                    } else {
                        Text("⚡︎")
                            .font(.system(size: 22))
                            .foregroundStyle(.green)
                        Text("\(activeStreak ?? 0) days streak")
                            .font(.system(size: 14, weight: .medium).monospaced())
                            .glowEffect(color: .green, radius: 6)
                    }
                    
                    
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

//MARK: - Progress View
struct StepProgress: View {
    let currentSteps: Int
    let goal: Int
    let row = 1
    
    private let totalSegments: Int = 7
    
    var body: some View {
        
        let progress = (Double(currentSteps)/Double(goal))
        let visibleSegments = progress >= 1.0 ? totalSegments : totalSegments - 1
        let filledSegments = min(Int(progress * Double(visibleSegments)), visibleSegments)
        
        HStack(spacing: 4) {
            ForEach(1...visibleSegments, id: \.self) { segment in
                
                let isFill = segment <= filledSegments
                Rectangle()
                    .frame(maxHeight: 5)
                    .foregroundStyle(isFill ? .green : .gray.opacity(0.4))
                    .glowEffect(color: .green, radius: 3)
            }
            
            if progress >= 1 {
                Rectangle()
                    .frame(maxHeight: 5)
                    .foregroundStyle(.green)
                    .glowEffect(color: .green, radius: 3)
                    .transition(.scale)
            }
        }
        .animation(.easeInOut, value: filledSegments)
    }
}

//MARK: - Debug Preview
#Preview {
    ContentView()
        .environmentObject(MainViewModel())
}




