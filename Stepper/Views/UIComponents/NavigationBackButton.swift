import SwiftUI

struct NavigationBackButton: View {
    var selector: () -> ()
    var body: some View {
        ZStack {
            Image(systemName: "arrow.backward")
                .font(.system(size: 20))
                .foregroundStyle(.green)
                .glowEffect(color: .green, radius: 4)
            
        }
        .onTapGesture {
            selector()
        }
        .frame(width: 80, height: 80)
    }
}
