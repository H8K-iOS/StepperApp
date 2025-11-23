import SwiftUI

struct GoalScreen: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: MainViewModel
    @State var sliderValue: CGFloat = 10000
    @State private var selectedColor: Color? = nil
    @State private var selectedGoal: Goal? = nil
    private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    private let array: [Goal] = [
        Goal(imageSystemName: "target", stepGoal: 5000, difficult: "easy", color: .cyan),
        Goal(imageSystemName: "chart.line.uptrend.xyaxis", stepGoal: 10000, difficult: "normal", color: .green),
        Goal(imageSystemName: "flame.fill", stepGoal: 15000, difficult: "hard", color: .orange),
        Goal(imageSystemName: "trophy.fill", stepGoal: 20000, difficult: "extreme", color: .pink)
    ]
    
    var body: some View {
        /// MARK: View Struct
        /// Background
        /// Step Grid
        /// Cstom Value Slider
        /// Save Buttons

        /// View
        ZStack {
            ///MARK: Background
            BackgroundGridView(spacing: 45)
            
            ///MARK: View
            VStack {
                HeaderView()
                
                Divider()
                    .glowEffect(color: .green, radius: 1)
                
                GridView()
                
                CustomValueView()
                
                HStack(spacing: 20) {
                    SaveButtonsView(title: "cancel", strokeClr: .pink,
                                    isSelected: self.selectedColor == .pink) {
                        self.selectedColor = .pink
                        ///
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.dismiss()
                        }
                    }
                    
                    SaveButtonsView(title: "save goal", strokeClr: .green,
                                    isSelected: self.selectedColor == .green) {
                        self.selectedColor = .green
                        ///
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            vm.goal = Int(sliderValue)
                            self.dismiss()
                        }
                    }
                }
            }
            //.padding(22)
            .navigationBarBackButtonHidden()
        }
        .padding(22)
        .frame(height: UIScreen.main.bounds.height)
        .overlay(alignment: .topLeading) {
            NavigationBackButton() {
                self.dismiss()
            }
                .padding(.top, 22)
        }
        .onAppear {
            self.sliderValue = CGFloat(vm.goal)
        }
    }
    
    //MARK: ViewBuilder
    @ViewBuilder
    func HeaderView() -> some View {
        VStack() {
            Text("> set goal <".uppercased())
                .font(.system(size: 34, weight: .medium, design: .monospaced))
                .foregroundStyle(.green)
                .glowEffect(color: .green, radius: 8)
            
            Text("daily step target".uppercased())
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .foregroundStyle(.green)
        }
        .padding(.bottom)
    }
    
    @ViewBuilder
    func GridView() -> some View {
        Text("> select dificulty <".uppercased())
            .font(.system(size: 12, weight: .medium, design: .monospaced))
            .foregroundStyle(.green)
            .padding(.top)
        
        LazyVGrid(columns: columns) {
            
            ForEach(array) { goal in
                let isSelected = selectedGoal?.id == goal.id
                let grdn = LinearGradient(colors: [goal.color.opacity(0.5),
                                                   goal.color.opacity(1),
                                                   goal.color.opacity(0.5),],
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing
                )
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? goal.color : goal.color.opacity(0.8), lineWidth: 1)
                    .glowEffect(color: isSelected ? goal.color : goal.color.opacity(0.8), radius: isSelected ? 12 : 6)
                    .frame(height: 120)
                    .overlay {
                        VStack(alignment: .center, spacing: 8) {
                            Image(systemName: goal.imageSystemName)
                                .font(.system(size: 22))
                            
                            Text("\(goal.stepGoal)")
                                .font(.system(size: 22, weight: .black))
                            
                            Text("\(goal.difficult)".uppercased())
                                .font(.system(size: 10))
                        }
                        
                        .foregroundStyle(isSelected ? goal.color : goal.color.opacity(0.8))
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(grdn.opacity(0.4))
                            .glowEffect(color: isSelected ? goal.color.opacity(0.5) : .clear, radius: 2)
                    )
                ///MARK: On Tap
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            selectedGoal = goal
                            self.sliderValue = CGFloat(goal.stepGoal)
                        }
                    }
            }
        }
        .padding(.vertical)
    }
    
    @ViewBuilder
    func CustomValueView() -> some View {
        Text("> or custom value <".uppercased())
            .font(.system(size: 12, weight: .medium, design: .monospaced))
            .foregroundStyle(.green)
        
        // Value
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.green)
                .frame(height: 120)
                .glowEffect(color: .green, radius: 4)
                .overlay {

                    VStack(alignment: .center) {
                        Text("\(Int(sliderValue))")
                            .font(.system(size: 44, weight: .medium, design: .monospaced))
                        Text("Steps".uppercased())
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                    }
                    .foregroundStyle(.green)
                    .glowEffect(color: .green, radius: 16)
                }
                .padding(.top)
        
        ///Slider
        CustomSlider(sliderValue: $sliderValue, in: 0...30000)
        HStack {
            Text("0")
                .font(.system(size: 10, weight: .bold))
            
            Spacer()
            
            Text("30.000")
                .font(.system(size: 10, weight: .bold))
        }
        .foregroundStyle(.green.opacity(0.5))
        .padding(.horizontal)
        .padding(.bottom, 4)
    }
    
    func SaveButtonsView(title: String, strokeClr: Color, isSelected: Bool, selector: @escaping() -> Void) -> some View {
        Button {
            selector()
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(strokeClr.opacity(0.8))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isSelected ? strokeClr.opacity(0.9) : strokeClr.opacity(0.4))
                            .glowEffect(color: isSelected ? strokeClr : .clear, radius: 4)
                }
                .overlay {
                    Text(title.uppercased())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(isSelected ? .black : strokeClr)
                }
        }

    }
}

#Preview {
    GoalScreen()
        .environmentObject(MainViewModel())
}
