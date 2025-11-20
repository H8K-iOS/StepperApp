//
//  StepperWidgetBundle.swift
//  StepperWidget
//
//  Created by Oleksandr Alimov on 19/11/25.
//

import WidgetKit
import SwiftUI

@main
struct StepperWidgetBundle: WidgetBundle {
    var body: some Widget {
        StepperWidget()
      //  StepperWidgetControl()
        StepperWidgetLiveActivity()
    }
}
