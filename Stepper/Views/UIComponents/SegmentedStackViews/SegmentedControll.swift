import SwiftUI

extension HomeStepView {
    /// - Segmented Controll
    @ViewBuilder
    func CustomSegmentedControll() -> some View {
        HStack(spacing: 0) {
            TappableText(.monthly)
                .foregroundStyle(.green.gradient)
                .frame(maxWidth: .infinity)
                .overlay {
                    /// - Current Tab
                    Rectangle()
                        .fill(.green.gradient)
                        .overlay {
                            TappableText(.daily)
                                .foregroundStyle(currentTab == .daily ? .black : .clear)
                                .scaleEffect(x: -1)
                        }
                        .overlay {
                            TappableText(.monthly)
                                .foregroundStyle(currentTab == .daily ? .clear : .black)
                            
                        }
                    
                        .rotation3DEffect(.init(degrees: currentTab == .monthly ? 0 : 180), axis: (x: 0, y: 1, z: 0), anchor: .trailing, perspective: 0.4)
                }
            //Back view
                .zIndex(1)
                .contentShape(Rectangle())
            
            TappableText(.daily)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.green.gradient)
                .glowEffect(color: .green, radius: 6)
                .zIndex(0)
        }
        .frame(maxWidth: .infinity)
        .background {
            Rectangle()
                .fill(.background)
                
            Rectangle()
                .stroke(.green, lineWidth: 3)
                .glowEffect(color: .green, radius: 6)
            
        }
        .rotation3DEffect(.init(degrees: shakeValue), axis: (0, 1, 0))
    }
    
    /// - Tappable Text
    @ViewBuilder
    func TappableText(_ tab: Tab) -> some View {
        Text(tab.rawValue)
            .font(.system(size: 10, weight: .medium).monospaced())
            .contentTransition(.interpolate)
            .padding(.vertical, 12)
            .padding(.horizontal, 40)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                    currentTab = tab
                }
                
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                    shakeValue = (tab == .daily ? 10 : -10)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                        shakeValue = 0
                    }
                }
            }
    }
}

#Preview {
    HomeStepView()
        .environmentObject(MainViewModel())
}
