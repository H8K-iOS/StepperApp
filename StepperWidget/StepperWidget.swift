//
//  StepperWidget.swift
//  StepperWidget
//
//  Created by Oleksandr Alimov on 19/11/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    let data = DataService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    goal: data.getGoal(),
                    steps: data.getSteps(),
                    streak: data.getStreak())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(),
                    goal: data.getGoal(),
                    steps: data.getSteps(),
                    streak: data.getStreak())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, goal: data.getGoal(), steps: data.getSteps(), streak: data.getStreak())
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let goal: Int
    let steps: Int
    let streak: Int
}

struct StepperWidgetEntryView : View {
    var entry: Provider.Entry
    
    let data = DataService()
    
    var body: some View {
        ZStack {
            BackgroundGridView(spacing: 20)
                .background(Color.black)
            
            VStack(alignment: .leading) {
                Text("\(data.getGoal())")
                    .font(.system(size: 24, weight: .bold).monospaced())
                
                Text("steps")
                    .font(.system(size: 18, weight: .medium).monospaced())
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                activityProgress
                
                StepProgress(progress: 4)
            }
        }
        .ignoresSafeArea()
        .background(Color.clear)
    }
    
}

struct StepperWidget: Widget {
    let kind: String = "StepperWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            StepperWidgetEntryView(entry: entry)
                .containerBackground(.clear , for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "HIII"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    StepperWidget()
} timeline: {
    SimpleEntry(date: .now, goal: 5000, steps: 4000, streak: 4)
    SimpleEntry(date: .now, goal: 5000, steps: 4000, streak: 4)
}

//Extenstion
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

extension StepperWidgetEntryView {
    var activityProgress: some View {
        HStack {
            Image(systemName: "shoeprints.fill")
                .font(.system(size: 16, weight: .medium).monospaced())
            
            
            Text("\(data.getStreak()) days!")
                .font(.system(size: 15, weight: .medium).monospaced())
        }
        .padding(.bottom, 0)
    }
}
