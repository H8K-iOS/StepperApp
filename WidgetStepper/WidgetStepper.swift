import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct WidgetStepperEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            
            
            Text("17,890")
                .font(.system(size: 24, weight: .bold).monospaced())
            
            Text("steps")
                .font(.system(size: 18, weight: .medium).monospaced())
                .foregroundStyle(.secondary)
            
            Spacer()
            
            activityProgress
            
            StepProgress(progress: 4)
        }
        .foregroundStyle(.green.gradient)
    }
}

struct WidgetStepper: Widget {
    let kind: String = "WidgetStepper"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WidgetStepperEntryView(entry: entry)
                .containerBackground(.black, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    WidgetStepper()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}

//MARK: - Extensions
struct StepProgress: View {
    let progress: Int
    let rows: Int = 2
    let segmentRow: Int = 5
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(1...rows, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(1...segmentRow, id: \.self) { segment in
                        let index = (row - 1) * segmentRow + segment
                        let isFill = index <= progress
                        
                        Rectangle()
                            .frame(maxHeight: 5)
                            .foregroundStyle(isFill ? .green : .secondary)
                    }
                }
            }
        }
        
    }
}

extension WidgetStepperEntryView {
    var progressBarView: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { _ in
                    Rectangle()
                        .frame(maxHeight: 5)
                }
            }
            
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { _ in
                    Rectangle()
                        .frame(maxHeight: 5)
                }
            }
            .foregroundStyle(.secondary)
        }
    }
    
    var activityProgress: some View {
        HStack {
            Image(systemName: "shoeprints.fill")
                .font(.system(size: 16, weight: .medium).monospaced())
            
            Text("111 days!")
                .font(.system(size: 15, weight: .medium).monospaced())
        }
        .padding(.bottom, 0)
    }
}
