import WidgetKit
import SwiftUI
import StepperShared

struct StepEntry: TimelineEntry {
    let date: Date
    let step: StepModel
}

struct StepProvider: TimelineProvider {
    
    
    func placeholder(in context: Context) -> StepEntry {
        StepEntry(date: Date(), step: StepModel(count: 1000, date: Date()))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (StepEntry) -> Void) {
        let entry = StepEntry(date: Date(), step: StepModel(count: 1000, date: Date()))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<StepEntry>) -> Void) {
        let entry = StepEntry(date: Date(), step: StepModel(count: 100, date: Date()))
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
        completion(timeline)
    }
}

struct StepWidgetEntryView: View {
    var entry: StepProvider.Entry
    
    @ViewBuilder
    var body: some View {
        let content = VStack {
            Text("Steps")
                .font(.caption)
                .bold()
            Text("\(entry.step.count)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        
        if #available(iOS 16.0, *) {
            content.containerBackground(for: .widget) {
                Color.gray
            }
        } else {
            content.background(.clear)
        }
    }
}

struct StepWidget: Widget {
    let kind: String = "StepWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StepProvider()) { entry in
            let base = StepWidgetEntryView(entry: entry)
            
            if #available(iOS 16.0, *) {
                base.containerBackground(for: .widget) {
                    Color.gray
                }
            } else {
                base.background(.clear)
            }
        }
        .configurationDisplayName("Stepper App")
        .description("Lets Do It")
        
        #if os(iOS)
        .supportedFamilies([.systemSmall, .systemMedium])
        #endif
    }
}
