import SwiftUI
import WidgetKit
import SharedUI

struct WidgetGalleryScreen: View {
    @State  private var selected: WidgetStyle = WidgetStyleService().load()
    
    var body: some View {
        ZStack {
            BackgroundGridView(spacing: 40)
            VStack {
                Text("> choose widget <".uppercased())
                    .font(.system(size: 34))
                    .foregroundStyle(.green)
                    .glowEffect(color: .green, radius: 6)
                
                Text("select from catalog".uppercased())
                    .font(.system(size: 14))
                    .foregroundStyle(.green)
                    .glowEffect(color: .green, radius: 6)
                
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
                }
                
            }
            
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    WidgetGalleryScreen()
}
