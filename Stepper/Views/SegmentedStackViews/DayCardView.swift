import SwiftUI

struct DayCardView: View {
    let step: StepModel
    @State private var dragOffset: CGSize = .zero
    @State private var topCardIndex: Int = 0
    var width: CGFloat = 180
    //debug
    var cards: [Color] = [.red, .blue, .green, .white, .yellow]
    
    
    var body: some View {
        ZStack {
            ForEach(cards.indices, id: \.self) { index in
                let visualIndex = (index - topCardIndex + cards.count) % cards.count
                let progress = min(abs(dragOffset.width) / 150, 1)
                let signedProgress = (dragOffset.width >= 0 ? 1 : -1) * progress
                
                
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: width, height: 250)
                        .foregroundStyle(.black.opacity(1).gradient)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.green, lineWidth: 1)
                        }
                        .glowEffect(color: .green, radius: 3)
                        .overlay {
                            VStack {
                                Text("17")
                                    .font(.system(size: 38, weight: .medium, design: .monospaced))
                                
                                Text("")
                            }
                        }
                    
                
                ///MARK:  offset + card position
                    .offset(x: visualIndex == 0 ? dragOffset.width : Double(visualIndex) * 10,
                            y: visualIndex == 0 ? 0 : Double(visualIndex) * -4)
                    .zIndex(Double(cards.count - visualIndex))
                
                    .rotationEffect(
                        .degrees(visualIndex == 0 ? 0 : Double(visualIndex) * 3 - progress * 3), anchor: .bottom
                    )
                
                    .scaleEffect( visualIndex == 0 ? 1.0 : visualIndex == 1
                                  ? (1.0 - Double(visualIndex) * 0.06 + progress * 0.06)
                                  : (1.0 - Double(visualIndex) * 0.06)
                    )
                
                    .offset(x: visualIndex == 0 ? 0 : Double(visualIndex) * -3)
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
                                            topCardIndex = (topCardIndex + 1) % cards.count
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
    DayCardView(step: StepModel(count: 1, date: Date()))
}
