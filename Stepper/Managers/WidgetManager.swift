import WidgetKit
import Foundation

//MARK: - Refresh Widget UI
protocol WidgetRefreshable {
    func refresh()
}

final class WidgetManager: WidgetRefreshable {
    func refresh() {
        WidgetCenter.shared.reloadTimelines(ofKind: "StepperWidget")
    }
}

final class WidgetStyleService {
    private let storage = UserDefaults(suiteName: "group.com.mycompany.stepperApp")
    
    private let kStyle = "WidgetStyle"
    
    func save(_ style: WidgetStyle) {
        self.storage?.set(style.rawValue, forKey: kStyle)
    }
    
    func load() -> WidgetStyle {
        WidgetStyle(rawValue: storage?.string(forKey: kStyle) ?? "steps") ?? .steps
    }
}

//MARK: - Widget Styles
/// available style
/// store userdefaults chosen style
/// get needed style + UI
