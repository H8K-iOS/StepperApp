import SwiftUI

struct CalendarColumnView: View {
    let day: String
    let isAchive: Bool
    
    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: "checkmark")
                .resizable()
                .frame(width: 12, height: 12)
                .foregroundStyle(isAchive ? .green : .gray.opacity(0.4))
                .glowEffect(color: isAchive ? .green : .clear, radius: 5)
               
            
        
            Text("\(day)")
                .font(.system(size: 18).monospaced())
                .foregroundStyle(.green.gradient)
                .glowEffect(color: .green, radius: 3)
        
            Rectangle()
                .frame(maxHeight: 2)
                .foregroundStyle(.green)
                .glowEffect(color: .green, radius: 3)
        }
        .frame(width: 25)
    }
}

