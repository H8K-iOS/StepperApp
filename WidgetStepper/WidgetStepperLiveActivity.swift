import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetStepperAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WidgetStepperLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetStepperAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WidgetStepperAttributes {
    fileprivate static var preview: WidgetStepperAttributes {
        WidgetStepperAttributes(name: "World")
    }
}

extension WidgetStepperAttributes.ContentState {
    fileprivate static var smiley: WidgetStepperAttributes.ContentState {
        WidgetStepperAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WidgetStepperAttributes.ContentState {
         WidgetStepperAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WidgetStepperAttributes.preview) {
   WidgetStepperLiveActivity()
} contentStates: {
    WidgetStepperAttributes.ContentState.smiley
    WidgetStepperAttributes.ContentState.starEyes
}
