import SwiftUI
import WidgetKit

struct HomeStepView: View {
    //MARK: Properties
    @EnvironmentObject var vm: MainViewModel
    @Environment(\.scenePhase) var scenePhase
    @State var currentTab: Tab = .monthly
    @State var shakeValue: CGFloat = 0
    @State private var days: [Date] = []
    @State private var date: Date = Date.now
    @State var showSheetGoal: Bool = false
    @State var showSheetWidget: Bool = false
   
    
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
                                selector: presentGoal,
                                goal: vm.goal,
                                activeStreak: vm.activeStreak,
                                previusStreak: vm.previusStreak)

                } else {
                    TodaysSteps(step: StepModel(count: 0, date: Date()),
                                selector: presentGoal,
                                goal: vm.goal,
                                activeStreak: vm.activeStreak,
                                previusStreak: vm.previusStreak)
                }
            
                // Widget Button
                widgetsButton
                
                // Segmented
                CustomSegmentedControll()
                
                /// Segmented Controll Setup
                TabControll()
                
                ///debug
                //list

            }
            
            .padding()
            .onChange(of: date) {
                days = date.calendarDisplayDays
                Task {
                    await self.vm.loadMonthSteps(date)
                }
                
            }
            
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    Task { try? await self.vm.healthStore.getTodaySteps() }
                    self.vm.widgetManager.refresh()
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
        
        .fullScreenCover(isPresented: $showSheetGoal) {
            GoalScreen(stepGoal: $vm.goal)
        }
        
        .fullScreenCover(isPresented: $showSheetWidget) {
            WidgetGalleryScreen()
        }
    }
    
    private func presentGoal() {
        self.showSheetGoal.toggle()
    }
    
    private func presentWidget() {
        self.showSheetWidget.toggle()
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
        List(vm.monthSteps) { step in
            HStack {
                Circle()
                    .frame(width: 10, height: 10)
                   // .foregroundStyle(isUnder10k(step.count) ? .red : .green)
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
            if !vm.monthSteps.isEmpty {
                ForEach(days, id: \.self) { day in
                    let dayForm = day.formatted(.dateTime.day())
                    let stepForDay = vm.monthSteps.first(where: {
                        Calendar.current.isDate($0.date, inSameDayAs: day)
                    })
                    
                    if day.monthInt != date.monthInt {
                        Text("")
                    } else {
                        CalendarColumnView(day: dayForm,
                                           isAchive: stepForDay != nil && stepForDay!.count >= vm.goal, isToday: Calendar.current.isDateInToday(day))
                    }
                }
            } else {
                ForEach(days, id: \.self) { day in
                    let dayForm = day.formatted(.dateTime.day())
                    if day.monthInt != date.monthInt {
                        Text("")
                    } else {
                        CalendarColumnPreview(day: dayForm)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func TabControll() -> some View {
        VStack(spacing: 0) {
                MonthPicker(date: $date)
                
                TabView(selection: $currentTab) {
                    VStack(spacing: 0) {
                        ShortDaySymbols()
                        CalendarView()
                            .padding(.vertical)
                            .tag(Tab.monthly)
                            .toolbar(.hidden, for: .tabBar)
                    }
                    .background(.clear)
                    
                    DayCardView(step: vm.monthSteps,
                                goal: vm.goal)
                    .tag(Tab.daily)
                    .toolbar(.hidden, for: .tabBar)
                    .background(.clear)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
    }

    
    //TODO: -
    private var widgetsButton: some View {
        Button {
            self.showSheetWidget.toggle()
        } label: {
            HStack {
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
                    .glowEffect(color: .green, radius: 6)
            }
        }
    }
}
