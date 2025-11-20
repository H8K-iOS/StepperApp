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

//MARK: - Widget Styles
/// available style
/// store userdefaults chosen style
/// get needed style + UI
