import SwiftUI


//MARK: - Is Authorized
struct CalendarColumnView: View {
    let day: String
    let isAchive: Bool
    
    var body: some View {
        VStack(spacing: 3) {
            RoundedRectangle(cornerRadius: 4)
                .fill(isAchive ? .green.opacity(0.8) : .gray.opacity(0.4))
                .frame(width: 14, height: 14)
                .overlay {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10))
                        .foregroundColor(isAchive ? .white : .gray.opacity(0.2))
                        .glowEffect(color: isAchive ? .green : .clear, radius: 5)
                }
            
        
            Text(day)
                .font(.system(size: 14).monospaced())
                .foregroundStyle(.green.gradient)
                .glowEffect(color: .green, radius: 3)
        
            Rectangle()
                .frame(maxHeight: 2)
                .foregroundStyle(isAchive ? .green : .gray.opacity(0.4))
                .glowEffect(color: isAchive ? .green : .clear, radius: 3)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 2)
    }
}

//MARK: - Is Not Authorized

struct CalendarColumnPreview: View {
    let day: String
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(.gray.opacity(0.2))
                .frame(width: 14, height: 14)
                .overlay {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
            
            Text(day)
                .foregroundStyle(.gray.opacity(0.3))
                .font(.system(size: 14).monospaced())
            
            Rectangle()
                .frame(maxHeight: 2)
                .foregroundStyle(.gray.opacity(0.2))
                .glowEffect(color: .gray, radius: 3)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 2)
    }
}

#Preview {
    HomeStepView()
        .environmentObject(MainViewModel())
}
