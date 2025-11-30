import SwiftUI

struct TodaysSteps: View {
    
    let step: StepModel?
    let selector: () -> ()
    let goal: Int
    let stepProgress: Int
    let activeStreak: Int?
    let previusStreak: Int?
    
    var body: some View {
        /// MARK: - View struct
        /// Background
        /// Overlay StepsView
        /// Progress View
        /// Streak View
        
        HStack {
            ///MARK: Background View
            Rectangle()
                .strokeBorder(Color.green, lineWidth: 3)
                .frame(maxWidth: .infinity, maxHeight: 180)
                .glowEffect(color: .green, radius: 6)
            
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        ///Steps View
                        StepsView()
                        
                        ///MARK: Progress view
                        StepProgress(currentSteps: step?.count ?? 0, goal: goal)
                            .padding(.vertical, 8)
                        
                        ///MARK: Streak Container
                        Rectangle()
                            .stroke(Color.green, lineWidth: 3)
                            .glowEffect(color: .green, radius: 6)
                            .padding(.vertical, 4)
                            .overlay(alignment: .leading) {
                                ///MARK: Streak View
                                StreakView()
                            }
                    }
                    .padding()
                }
            ///MARK: Goal Image
                .overlay(alignment: .topTrailing) {
                    GoalImageButton()
                }
        }
    }
    
    @ViewBuilder
    func StepsView() -> some View {
        VStack(alignment: .leading) {
            Text("\(step?.count ?? 0)")
                .font(.system(size: 42, weight: .bold).monospaced())
            Text("Steps today")
                .font(.system(size: 14, weight: .medium).monospaced())
        }
        .foregroundStyle(.green)
        .glowEffect(color: .green, radius: 3)
    }
    
    @ViewBuilder
    func StreakView() -> some View {
        HStack {
            if let prev = previusStreak, previusStreak != 0, (activeStreak == 0) {
                Text("⚡︎")
                    .font(.system(size: 22))
                    .foregroundStyle(.red)
                    .blinkAnimation()
                
                Text("\(prev) day streak at risk!")
                    .font(.system(size: 16, weight: .medium).monospaced())
                    .foregroundStyle(.red)
                    .glowEffect(color: .red, radius: 6)
                    .blinkAnimation()
            } else {
                Text("⚡︎")
                    .font(.system(size: 22))
                    .foregroundStyle(.green)
                
                Text("\(activeStreak ?? 0) days streak")
                    .font(.system(size: 16, weight: .medium).monospaced())
                    .glowEffect(color: .green, radius: 6)
            }
        }
        .foregroundStyle(.green)
        .padding(.leading)
    }
    
    @ViewBuilder
    func GoalImageButton() -> some View {
        Image(systemName: "medal.fill")
            .padding()
            .foregroundStyle(
                LinearGradient(colors: [.green.opacity(0.3), .green.opacity(0.8), .green.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .onTapGesture {
                selector()
            }

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
    HomeStepView()
        .environmentObject(MainViewModel())
}




