import Foundation
import SwiftUI
import Observation

@Observable
final class Router {
    var path = NavigationPath()
    
    func navigateToSetAGoal() {
        path.append(Route.goal)
    }
    
    func popLast() {
        path.removeLast(path.count)
    }
    
    ///to expend if needed
}
    
enum Route: Hashable {
    case goal
    
    ///to expend if needed
}
