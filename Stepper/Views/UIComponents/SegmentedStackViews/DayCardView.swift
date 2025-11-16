import SwiftUI

struct DayCardView: View {
    var step: [StepModel]
    var goal: Int
    @State private var dragOffset: CGSize = .zero
    @State private var topCardIndex: Int = 0
    var width: CGFloat = 240
    //debug
    var cards: [Color] = [.red, .blue, .green, .white, .yellow]
    
    
    var body: some View {
        ZStack {
            ForEach(step.indices, id: \.self) { index in
                let visualIndex = (index - topCardIndex + step.count) % step.count
                let progress = min(abs(dragOffset.width) / 150, 1)
                let signedProgress = (dragOffset.width >= 0 ? 1 : -1) * progress
                
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: width, height: width)
                    .foregroundStyle(.black.opacity(1).gradient)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.green, lineWidth: 1)
                    }
                    .glowEffect(color: .green, radius: 3)
                
                ///MARK: Card UI Setup
                    .overlay {
                        VStack {
                            VStack {
                                Text("[step count]".uppercased())
                                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                                    .foregroundStyle(.green)
                                
                                Text("\(step[index].count)")
                                    .foregroundStyle(.green)
                                    .font(.system(size: 48, weight: .medium, design: .monospaced))
                                    .glowEffect(color: .green, radius: 10)
                            }
                            
                            Rectangle()
                                .fill(
                                    LinearGradient(colors: [.green.opacity(0.4), .green, .green.opacity(0.4),],
                                                   startPoint: .leading,
                                                   endPoint: .trailing)
                                    
                                )
                            
                                .frame(height: 1)
                                .padding(.horizontal)
                            VStack(alignment: .center) {
                                Text("\(step[index].date.formatted(.dateTime.month().day()))")
                                    .font(.system(size: 32, weight: .medium, design: .monospaced))
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "trophy")
                                        .foregroundStyle(.green)
                                        .font(.system(size: 12))
                                    
                                    let percent = Int((Double(step[index].count) / Double(goal)) * 100)
                                    Text("\(percent)% complete".uppercased())
                                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                                        .foregroundStyle(.green)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                
                
                ///MARK:  offset + card position
                    .offset(x: visualIndex == 0 ? dragOffset.width : Double(min(visualIndex, 5)) * 10,
                            y: visualIndex == 0 ? 0 : Double(min(visualIndex, 5)) * -4)
                    .zIndex(Double(step.count - visualIndex))
                
                    .rotationEffect(
                        .degrees(visualIndex == 0 ? 0 : Double(visualIndex) * 3 - progress * 3), anchor: .bottom
                    )
                
                    .scaleEffect( visualIndex == 0 ? 1.0 : visualIndex == 1
                                  ? (1.0 - Double(visualIndex) * 0.06 + progress * 0.06)
                                  : (1.0 - Double(visualIndex) * 0.06)
                    )
                    .offset(x: visualIndex == 0 ? 0 : Double(visualIndex) * 20)
                    .rotation3DEffect(.degrees(
                        (visualIndex == 0 || visualIndex == 1) ? 10 * signedProgress : 0),
                                      axis: (0,1,0)
                    )
                    .contentShape(Rectangle())
                
                ///MARK: - swipe left/right cards
                    .gesture(
                        
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                dragOffset = value.translation
                            }
                        
                            .onEnded { value in
                                let treshold: CGFloat = 50
                                let direction: CGFloat = value.translation.width > 0 ? 1 : -1
                                let delay = direction < 0 ? 0.18 : 0.20
                                
                                if abs(value.translation.width) > treshold {
                                    let direction: CGFloat = value.translation.width > 0 ? 1 : -1
                                    
                                    withAnimation(.smooth(duration: 0.2)) {
                                        dragOffset.width = direction > 0 ? -width : width * 1.33
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                        withAnimation(.smooth(duration: 0.5)) {
                                            topCardIndex = (topCardIndex + 1) % step.count
                                            dragOffset = .zero
                                        }
                                    }
                                } else {
                                    withAnimation {
                                        dragOffset = .zero
                                    }
                                }
                            }
                    )
            }
        }
        .padding()
    }
}

#Preview {
    DayCardView(step: [StepModel(count: 12543, date: Date()),
                       StepModel(count: 9000, date: Date()),
                       StepModel(count: 7000, date: Date())], goal: 8000)
}

