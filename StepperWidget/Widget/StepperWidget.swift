import WidgetKit
import SwiftUI
import Foundation
import StepperSharedUI


struct Provider: AppIntentTimelineProvider {
    let data = DataService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now,
                    style: WidgetStyleService().load())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let selected = WidgetStyleService().load()
        return SimpleEntry(date: .now,
                           style: selected)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let style = WidgetStyleService().load()
        let entry = SimpleEntry(date: .now,
                                style: style)
        
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
    
    var body: some View {
        switch entry.style {
            case .steps:
                StepsWidgetView(data: data)
               case .calories:
            CaloriesWidgetView(data: data)
               case .distance:
            DistanceWidgetView()
        }
    }
    
}

struct StepperWidget: Widget {
    let kind: String = "StepperWidget"
    let grdn = LinearGradient(colors: [.gray.opacity(0.2),
                                       .green.opacity(0.2),
                                       .black,
                                       .green.opacity(0.2),
                                       .gray.opacity(0.2)],
                              startPoint: .topLeading,
                              endPoint: .bottomTrailing)
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: ConfigurationAppIntent.self,
                               provider: Provider()) { entry in
            StepperWidgetEntryView(entry: entry)
                .containerBackground(grdn, for: .widget)
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
    SimpleEntry(date: Date(), style: .steps)
    //SimpleEntry()
}

//Extenstion

