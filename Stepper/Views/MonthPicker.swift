import SwiftUI

struct MonthPicker: View {
    @Binding var date: Date
    
    private var monthYear: String {
        date.formatted(.dateTime.month(.wide).year())
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: prevMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.green)
                    .glowEffect(color: .green, radius: 8)
            }
            .buttonStyle(.plain)
            
            Text(monthYear)
                .font(.system(size: 18, weight: .semibold, design: .monospaced))
                .foregroundColor(.green)
                .frame(minWidth: 150)
                .id(monthYear)
                .transition(.opacity.combined(with: .slide))
                .animation(.snappy, value: date)
                .glowEffect(color: .green, radius: 10)
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.green)
                    .glowEffect(color: .green, radius: 8)
                
            }
        }
    }
    
    //MARK: - Methods
    private func prevMonth() {
        date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
    }
    
    private func nextMonth() {
        date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
    }
}
#Preview {
    ContentView()
        .environmentObject(MainViewModel())
}

