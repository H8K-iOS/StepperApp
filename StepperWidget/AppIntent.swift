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

public enum WidgetStyle: String, AppEnum {
    case steps
    case distance
    
    public static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Widget Style")
    
    public static let caseDisplayRepresentations: [WidgetStyle : DisplayRepresentation] = [
        .steps: "Steps",
        .distance: "Distance"
    ]
}
