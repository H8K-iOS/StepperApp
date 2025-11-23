import Foundation
import SwiftUI
import Observation

@Observable
class Router {
    var path = NavigationPath()
    
    func navigateToGoalScreen() {
        path.append(Route.goalScreen)
    }
    
    func navigateToWidgetGalleryScreen() {
        path.append(Route.widgetGalleryScreen)
    }
    
    func popLast() {
        path.removeLast(path.count)
    }
}

enum Route: Hashable {
    case goalScreen
    case widgetGalleryScreen
}
