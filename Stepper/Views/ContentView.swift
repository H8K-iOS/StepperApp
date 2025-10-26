import SwiftUI

struct ContentView: View {
    //MARK: Properties
    @EnvironmentObject var vm: MainViewModel
    @State var currentTab: Tab = .daily
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
        VStack(spacing: 22) {
            // Steps View
            if let step = vm.todaySteps.first {
                TodaysSteps(step: step, stepProgress: 4)
            }
            // Widget Button
            widgetsButton
            
            
            // Segmented
            CustomSegmentedControll()
            
            //Picker
            MonthPicker(date: $date)
            
            ///Calendar setup
            
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .foregroundStyle(.green.opacity(0.6))
                        .font(.system(size: 14).monospaced())
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: columns) {
                ForEach(days, id: \.self) { days in
                    let day = days.formatted(.dateTime.day())
                    if days.monthInt != date.monthInt  {
                        Text("")
                    } else {
                        CalendarColumnView(day: day, isAchive: true)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            days = date.calendarDisplayDays
        }
        .onChange(of: date) {
            days = date.calendarDisplayDays
        }
    }
    
    //TODO: - Calendar
    ///- Test Tabs
    /*
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
     */
    
}

#Preview {
    ContentView()
        .environmentObject(MainViewModel())
}

//MARK: - Extensions UI
extension ContentView {
    //MARK: - UI for history tab
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
    
    /*
    private var segmentedControllSetup: some View {
        TabView(selection: $currentTab) {
            TestTabs()
                .tag(Tab.daily)
            TestTabs(true)
                .tag(Tab.monthly)
        }
    }
    */
    
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
