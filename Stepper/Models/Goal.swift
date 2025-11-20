import Foundation
import SwiftUI

struct Goal: Identifiable {
    let id = UUID()
    let imageSystemName: String
    let stepGoal: Int
    let difficult: String
    let color: Color
}
