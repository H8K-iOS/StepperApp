import SwiftUI
import WidgetKit
import StepperSharedUI

struct WidgetPreviewItem: Identifiable {
    let id: UUID = UUID()
    let title: String
    let size: WidgetFamily
    let stroke: Color
    let view: AnyView
}

struct WidgetGalleryScreen: View {
    @Environment(\.dismiss) var dismiss
    @State private var selected: WidgetStyle = WidgetStyleService().load()
    @State private var rotateIn3D: Bool = false
    let data = DataService()
    let gradient: [Color] = [.gray.opacity(0.2), .black]
    let columns: [GridItem] = [GridItem(.flexible())]
    let widgth = UIScreen.main.bounds.width * 0.9
    let widgetItems: [WidgetPreviewItem] = [
        WidgetPreviewItem(title: "Steps - Small",
                          size: .systemSmall,
                          stroke: .green,
                          view: AnyView(
                            StepsWidgetView(steps: 4999,
                                            goal: 10000,
                                            streak: 2,
                                            familyOveride: .systemSmall
                                           )
                            .frame(width: 120, height: 120)
                          )
                         ),
        
        WidgetPreviewItem(title: "Steps Widget",
                          size: .systemMedium,
                          stroke: .green,
                          view: AnyView(
                            StepsWidgetView(steps: 4999,
                                            goal: 10000,
                                            streak: 2,
                                            familyOveride: .systemMedium
                                           )
                            .frame(width: 300, height: 120)
                          )
                         ),
        
        WidgetPreviewItem(title: "Distance - Small",
                          size: .systemSmall,
                          stroke: .blue,
                          view: AnyView(
                            DistanceWidgetView(distance: 1.3,
                                               steps: 2000,
                                               goal: 5000,
                                               familyOverride: .systemSmall
                                              )
                            .frame(width: 120, height: 120)
                          )
                         ),
        
        WidgetPreviewItem(title: "Distance Widget",
                          size: .systemMedium,
                          stroke: .blue,
                          view: AnyView(
                            DistanceWidgetView(distance: 1.3,
                                               steps: 2000,
                                               goal: 5000,
                                               familyOverride: .systemMedium
                                              )
                            .frame(width: 300, height: 120)
                          )
                         )
    ]
    
    var body: some View {
        ZStack {
            BackgroundGridView(spacing: 40)
            
            VStack {
                Text("> widget preview <".uppercased())
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.green)
                    .glowEffect(color: .green, radius: 10)
                
                Text("> tap to select <".uppercased())
                    .font(.system(size: 12))
                    .foregroundStyle(.green)
                    .glowEffect(color: .green, radius: 6)
                
                MediumWidgetsGrid()
                
                divider
                
                Text("> circular variants <".uppercased())
                    .font(.system(size: 12))
                    .foregroundStyle(.green)
                    .glowEffect(color: .green, radius: 6)
                
                
                SmallWidgetsView()

                Spacer()
                
                BackButton()
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                self.rotateIn3D.toggle()
            }
        }
    }
    
    @ViewBuilder
    func MediumWidgetsGrid() -> some View {
        LazyVGrid(columns: columns, spacing: 15) {
            let filtered = widgetItems.filter {$0.size == .systemMedium}
            
            ForEach(filtered.reversed()) { widget in
                VStack {
                    Text(widget.title)
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundStyle(widget.stroke.opacity(0.4))
                    
                    widget.view
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.black)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .foregroundStyle(
                                            LinearGradient(colors: [.gray.opacity(0.2),
                                                                    widget.stroke.opacity(0.2),
                                                                    .black,
                                                                    widget.stroke.opacity(0.2),
                                                                    .gray.opacity(0.2)],
                                                           startPoint: .topLeading,
                                                           endPoint: .bottomTrailing)
                                        )
                                }
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(widget.stroke, lineWidth: 3)
                                .glowEffect(color: widget.stroke, radius: 8)
                            
                            
                        }
                }
            }
            .rotation3DEffect(.degrees(rotateIn3D ? 4 : -2),
                              axis: (x: 90,
                                     y: 45,
                                     z: 0)
            )
        }
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    func SmallWidgetsView() -> some View {
        HStack(alignment: .center) {
            let filtered = self.widgetItems.filter {$0.size == .systemSmall}
            ForEach(filtered.reversed()) { widget in
                Spacer()
                widget.view
                    .padding(25)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(
                                        LinearGradient(colors: [.gray.opacity(0.2),
                                                                widget.stroke.opacity(0.2),
                                                                .black,
                                                                widget.stroke.opacity(0.2),
                                                                .gray.opacity(0.2)],
                                                       startPoint: .topLeading,
                                                       endPoint: .bottomTrailing)
                                    )
                            }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(widget.stroke, lineWidth: 3)
                            .glowEffect(color: widget.stroke, radius: 4)
                    }
                    .rotation3DEffect(.degrees(rotateIn3D ? 4 : -2),
                                      axis: (x: 20,
                                             y: -25,
                                             z: 0)
                    )
                Spacer()
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func BackButton() -> some View {
        Button {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.dismiss()
            }
        } label: {
            Text("> back to main <".uppercased())
                .font(.system(size: 14))
                .foregroundStyle(.red.opacity(0.7))
                .glowEffect(color: .red, radius: 6)
        }
    }
}


private extension WidgetGalleryScreen {
    var divider: some View {
        Rectangle()
            .frame(height: 1)
            .frame(width: UIScreen.main.bounds.width * 0.88)
            .foregroundStyle(.green)
            .glowEffect(color: .green, radius: 3)
            .padding()
    }
}


#Preview {
    WidgetGalleryScreen()
}
