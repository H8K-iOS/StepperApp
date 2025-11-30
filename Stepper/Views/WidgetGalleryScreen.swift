import SwiftUI
import WidgetKit
import StepperSharedUI

struct WidgetGalleryScreen: View {
    @State  private var selected: WidgetStyle = WidgetStyleService().load()
    let data = DataService()
    let gradient: [Color] = [.gray.opacity(0.2), .black]
    var body: some View {
        ZStack {
            BackgroundGridView(spacing: 40)
                //.background(LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomLeading))
            VStack {
                Text("> choose widget <".uppercased())
                    .font(.system(size: 34))
                    .foregroundStyle(.green)
                    .glowEffect(color: .green, radius: 6)
                
                Text("select from catalog".uppercased())
                    .font(.system(size: 14))
                    .foregroundStyle(.green)
                    .glowEffect(color: .green, radius: 6)
                
                
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(.black)
                    .overlay {
                        CaloriesWidgetView(calories: 10, goalCalories: 100)
                            .padding(10)
                    }
                    .glowEffect(color: .green, radius: 3)
                    .frame(width: 140, height: 140)
                
                
                Spacer()
                
                Text("> tap to select <".uppercased())
                    .font(.system(size: 12))
                    .foregroundStyle(.green)
                    .glowEffect(color: .green, radius: 6)
                
                Picker("style", selection: $selected) {
                    ForEach(WidgetStyle.allCases, id: \.self) { style in
                        Text(style.rawValue.capitalized).tag(style)
                    }
                    .pickerStyle(.segmented)
                }
                
                Button("Save") {
                    WidgetStyleService().save(selected)
                    WidgetManager().refresh()
                }
                
            }
        }
    }
}

#Preview {
    WidgetGalleryScreen()
}
