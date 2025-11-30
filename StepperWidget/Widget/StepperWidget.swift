import WidgetKit
import SwiftUI
import Foundation
import StepperSharedUI


struct Provider: AppIntentTimelineProvider {
    let data = DataService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now,
                    style: .steps)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
       
        return SimpleEntry(date: .now,
                           style: configuration.style)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let entry = SimpleEntry(date: .now,
                                style: configuration.style)
        
        return Timeline(entries: [entry], policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let style: WidgetStyle
}

struct StepperWidgetEntryView : View {
    var entry: Provider.Entry
    
    let data = DataService()
  
    private var height: CGFloat = 10
    
    let distance = 1.7
    
    init(entry: Provider.Entry) {
            self.entry = entry
    }
    
    var body: some View {
        switch entry.style {
        case .steps:
            StepsWidgetView(steps: data.getSteps(), goal: data.getGoal(), streak: data.getStreak())
        case .calories:
            CaloriesWidgetView(calories: 100, goalCalories: 200)
        case .distance:
            DistanceWidgetView(distance: 1, steps: data.getSteps(), goal: data.getGoal())
        }
    }
}

struct StepperWidget: Widget {
    let kind: String = "StepperWidget"
    let grdnSteps = LinearGradient(colors: [.gray.opacity(0.2),
                                            .green.opacity(0.2),
                                            .black,
                                            .green.opacity(0.2),
                                            .gray.opacity(0.2)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
    
    let grdnCalories = LinearGradient(colors: [.gray.opacity(0.2),
                                               .orange.opacity(0.1),
                                               .black,
                                               .orange.opacity(0.1),
                                               .gray.opacity(0.2)],
                                      startPoint: .topLeading,
                                      endPoint: .bottomTrailing)
    
    let grdnDistance = LinearGradient(colors: [.gray.opacity(0.2),
                                               .blue.opacity(0.3),
                                               .black,
                                               .blue.opacity(0.3),
                                               .gray.opacity(0.2)],
                                      startPoint: .topLeading,
                                      endPoint: .bottomTrailing)
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: ConfigurationAppIntent.self,
                               provider: Provider()) { entry in
            StepperWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    bgForWidget(entry.style)
                }
        }
                               .supportedFamilies([.systemSmall, .systemMedium])
    }
    
    //MARKL: - Widget Appearence
    @ViewBuilder
    func bgForWidget(_ style: WidgetStyle) -> some View {
        switch style {
        case .steps:
            grdnSteps
        case .calories:
            grdnCalories
        case .distance:
            grdnDistance
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var steps: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.style = .steps
        return intent
    }
    
    fileprivate static var calories: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.style = .steps
        return intent
    }
}

#Preview(as: .systemSmall) {
    StepperWidget()
} timeline: {
    SimpleEntry(date: Date(), style: .distance)
    //SimpleEntry()
}
//Extenstion

