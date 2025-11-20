import SwiftUI

///MARK: Views extension
extension View {
    func glowEffect(color: Color, radius: CGFloat) -> some View {
        self
            .shadow(color: color.opacity(0.7), radius: radius)
            .shadow(color: color.opacity(0.4), radius: radius / 2)
            .shadow(color: color.opacity(0.25), radius: radius / 4)
    }
    
    func blinkAnimation(duration: Double = 2) -> some View {
        modifier(BlinkModifier(duration: duration))
    }
}

struct BlinkModifier: ViewModifier {
    let duration: Double
    @State var isVisible = true
    
    func body(content: Content) -> some View {
            content
            .opacity(isVisible ? 0.6 : 0.2)
                .onAppear {
                    withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                        isVisible.toggle()
                    }
                }
        }
}

