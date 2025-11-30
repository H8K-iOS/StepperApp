import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Widget Settings" }
    static var description: IntentDescription { "Choose widget style" }

    @Parameter(title: "Widget Style", default: WidgetStyle.steps)
    var style: WidgetStyle
    
    
    func perform() async throws -> some IntentResult {
        WidgetStyleService().save(style)
        return .result()
    }
}

enum WidgetStyle: String, AppEnum {
    case steps
    case calories
    case distance
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Widget Style")
    
    static var caseDisplayRepresentations: [WidgetStyle : DisplayRepresentation] = [
        .steps: "Steps",
        .calories: "Calories",
        .distance: "Distance"
    ]
    
    
}
