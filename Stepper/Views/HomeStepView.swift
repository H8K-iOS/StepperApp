import SwiftUI

struct HomeStepView: View {
    //MARK: Properties
    @EnvironmentObject var vm: MainViewModel
    @Environment(Router.self) var router
    @State var currentTab: Tab = .monthly
    @State var shakeValue: CGFloat = 0
    @State private var days: [Date] = []
    @State private var date: Date = Date.now
    
    let daysOfWeek = Date.cpitalizedFirstLetterOfWeek
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
  
    //MARK: Initializers
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            ///MARK: Background
            BackgroundGridView(spacing: 5)
            
            ///MARK: View
            VStack(spacing: 22) {
                // Steps View
                if let step = vm.todaySteps.first {
                    TodaysSteps(step: step,
                                goal: vm.goal,
                                stepProgress: 4,
                                activeStreak: vm.activeStreak,
                                previusStreak: vm.previusStreak,
                                selector: router.navigateToSetAGoal)
                }
                
                // Widget Button
                widgetsButton
                
                // Segmented
                CustomSegmentedControll()
                
                /// Segmented Controll Setup
                TabControll()
                
                ///debug
                //list
                
                Spacer()
            }
            .padding()
            
            .onChange(of: date) {
                days = date.calendarDisplayDays
                Task {
                    await self.vm.loadMonthSteps(date)
                }
            }
            
            .onAppear {
                days = date.calendarDisplayDays
                Task {
                    await vm.loadMonthSteps(date)
                    await vm.loadStepsForAllTime()
                }
            }
        }
    }
}

#Preview {
    HomeStepView()
        .environmentObject(MainViewModel())
}

//MARK: - Extensions UI
extension HomeStepView {
    //MARK: - UI for history tab
    private var list: some View {
        List(vm.montSteps) { step in
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
    
    @ViewBuilder
    func ShortDaySymbols() -> some View {
        HStack {
            ForEach(daysOfWeek.indices, id: \.self) { index in
                Text(daysOfWeek[index])
                    .foregroundStyle(.green.opacity(0.6))
                    .font(.system(size: 14).monospaced())
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    @ViewBuilder
    func CalendarView() -> some View {
        LazyVGrid(columns: columns) {
            ForEach(days, id: \.self) { day in
                let dayForm = day.formatted(.dateTime.day())
                let stepForDay = vm.montSteps.first(where: {
                    Calendar.current.isDate($0.date, inSameDayAs: day)
                })
                
                if day.monthInt != date.monthInt {
                    Text("")
                } else {
                    CalendarColumnView(day: dayForm, isAchive: stepForDay != nil && stepForDay!.count >= vm.goal)
                }
            }
        }

    }
    
    @ViewBuilder
    func TabControll() -> some View {
            VStack {
                MonthPicker(date: $date)
                
                TabView(selection: $currentTab) {
                    VStack {
                        ShortDaySymbols()
                        CalendarView()
                            .padding(.vertical)
                            .tag(Tab.monthly)
                            .toolbar(.hidden, for: .tabBar)
                    }
                    .background(.clear)
                    
                    DayCardView(step: vm.montSteps,
                                goal: vm.goal)
                    .tag(Tab.daily)
                    .toolbar(.hidden, for: .tabBar)
                    .background(.clear)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                Spacer()
            }
    }
    
    //TODO: -
    private var widgetsButton: some View {
        HStack{
            Text("Widget Gallery")
            
            Spacer()
            
            Image(systemName: "chevron.right.2")
        }
        .frame(maxHeight: 22)
        .foregroundStyle(.green.gradient)
        .font(.system(size: 16, weight: .semibold).monospaced())
        .padding()
        .overlay {
            Rectangle()
                .stroke(.green.gradient, lineWidth: 3)
        }
        .glowEffect(color: .green, radius: 6)
    }
}
