import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: MainViewModel
    @State var currentTab: Tab = .daily
    @State var shakeValue: CGFloat = 0
    //MARK: Initializers
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 22) {
            // Steps View
            if let step = vm.todaySteps.first {
                TodaysSteps(step: step)
            }
            // Widget Button
            widgetsButton
            // Segmented
            CustomSegmentedControll()
            
            TabView(selection: $currentTab) {
                TestTabs()
                    .tag(Tab.daily)
                TestTabs(true)
                    .tag(Tab.monthly)
            }
        }
        .padding()
    }
    
    /// - Segmented Controll
    @ViewBuilder
    func CustomSegmentedControll() -> some View {
        HStack(spacing: 0) {
            TappableText(.daily)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.green.gradient)
                .overlay {
                    /// - Current Tab
                    Rectangle()
                        .fill(.green.gradient)
                        .overlay {
                            TappableText(.monthly)
                                .foregroundStyle(currentTab == .monthly ? .black : .clear)
                                .scaleEffect(x: -1)
                        }
                        .overlay {
                            TappableText(.daily)
                                .foregroundStyle(currentTab == .monthly ? .clear : .black)
                        }
                    
                        .rotation3DEffect(.init(degrees: currentTab == .daily ? 0 : 180), axis: (x: 0, y: 1, z: 0), anchor: .trailing, perspective: 0.4)
                }
            //Back view
                .zIndex(1)
                .contentShape(Rectangle())
            
            TappableText(.monthly)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.green.gradient)
                .zIndex(0)
        }
        .frame(maxWidth: .infinity)
        .background {
            Rectangle()
                .fill(.background)
            
            Rectangle()
                .stroke(.green, lineWidth: 3)
                .shadow(color: .white, radius: 3)
            
        }
        .rotation3DEffect(.init(degrees: shakeValue), axis: (0, 1, 0))
    }
    
    /// - Tappable Text
    @ViewBuilder
    func TappableText(_ tab: Tab) -> some View {
        Text(tab.rawValue)
            .font(.title3)
            .fontWeight(.semibold)
            .contentTransition(.interpolate)
            .padding(.vertical, 12)
            .padding(.horizontal, 40)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                    currentTab = tab
                }
                
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                    shakeValue = (tab == .monthly ? 10 : -10)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                        shakeValue = 0
                    }
                }
            }
    }
    
    //TODO: -
    ///- Test Tabs
    @ViewBuilder
    func TestTabs(_ displayRed: Bool = false) -> some View {
        if displayRed {
            Rectangle()
                .fill(.red)
                .frame(width: 40, height: 40)
        } else {
            Rectangle()
                .fill(.blue)
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MainViewModel())
}

//MARK: - Extensions UI
extension ContentView {
    private var list: some View {
        List(vm.weekSteps.dropFirst()) { step in
            HStack {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(isUnder10k(step.count) ? .red : .green)
                Text("\(step.count)")
                Spacer()
                Text(step.date.formatted(date: .abbreviated, time: .omitted))
            }
        }
    }
    
    private var widgetsButton: some View {
        HStack{
            Text("Widget Gallery")
            
            Spacer()
            
            Image(systemName: "chevron.right.2")
        }
        .foregroundStyle(.green.gradient)
        .font(.system(size: 16, weight: .semibold).monospaced())
        .padding()
        .border(.green, width: 3)
        .shadow(color: .white, radius: 1)
        
    }
}
