import SwiftUI

struct MonthPicker: View {
    @Binding var date: Date
    
    private var monthYear: String {
        date.formatted(.dateTime.month(.wide).year())
    }
    
    var body: some View {
        HStack(spacing: 20) {
            NavButton(image: "chevron.left", action: prevMonth)
            
            Spacer()
            
            Text(monthYear)
                .font(.system(size: 18, weight: .semibold, design: .monospaced))
                .foregroundColor(.green)
                .frame(minWidth: 150)
                .id(monthYear)
                .transition(.opacity.combined(with: .slide))
                .animation(.snappy, value: date)
                .glowEffect(color: .green, radius: 10)
            
            Spacer()
            
           NavButton(image: "chevron.right", action: nextMonth)
        }
    }
    
    //MARK: - Methods
    private func prevMonth() {
        date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
    }
    
    private func nextMonth() {
        date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
    }
    
    ///MARK: UI methods
    ///
    @ViewBuilder
    func NavButton(image: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: image)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.green)
                .glowEffect(color: .green, radius: 8)
            
        }
        .padding(10)
        .overlay {
            Rectangle()
                .stroke(.green, lineWidth: 2)
                .glowEffect(color: .green, radius: 4)
                
        }
    }
}
#Preview {
    HomeStepView()
        .environmentObject(MainViewModel())
}



