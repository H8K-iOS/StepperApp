import SwiftUI

struct CustomSlider: View {
    @Binding var sliderValue: CGFloat
    var range: ClosedRange<CGFloat>
    var config: Config
    
    init(sliderValue: Binding<CGFloat>, in range: ClosedRange<CGFloat>, config: Config = .init()) {
        self._sliderValue = sliderValue
        self.range = range
        self.config = config
        self.lastStoredValue = sliderValue.wrappedValue
    }
    
    @State var lastStoredValue: CGFloat
    @GestureState var isActive: Bool = false
    var body: some View {
        GeometryReader {
            let size = $0.size
            let width = (sliderValue / range.upperBound) * size.width
            
            ZStack {
                Rectangle()
                    .fill(config.inActiveTint)
                
                Rectangle()
                    .fill(config.activeTint)
                    .mask(alignment: .leading) {
                        Rectangle()
                            .frame(width: width)
                    }
            }
            .glowEffect(color: config.activeTint, radius: 6)
            .contentShape(.rect)
            .highPriorityGesture(
            DragGesture(minimumDistance: 0)
                .updating($isActive) { _, out, _ in
                    out = true
                }
                .onChanged { value in
                    let progress = ((value.translation.width / size.width) * range.upperBound) + lastStoredValue
                    self.sliderValue = max(min(progress, range.upperBound), range.lowerBound)
                }.onEnded { _ in
                    lastStoredValue = sliderValue
                }
            )
        }
        .frame(height: 30 + config.extraHeight)
        .mask {
            RoundedRectangle(cornerRadius: config.cornerRadius)
                .frame(height: 30 + (isActive ? config.extraHeight : 0))
        }
        .animation(.snappy, value: isActive)
    }
    
    struct Config {
        var inActiveTint: Color = .green.opacity(0.2)
        var activeTint: Color = .green
        var extraHeight: CGFloat = 25
        var cornerRadius: CGFloat = 15
        ///MARK: Overlay Props
        var overlayActiveTint: Color = .white
        var overlayInActiveTint: Color = .white
        
    }
}
#Preview {
  //  GoalScreen()
}
