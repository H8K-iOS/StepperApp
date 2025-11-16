import SwiftUI

struct GoalScreen: View {
    
    @State var sliderValue: Double = 0
    var body: some View {
        /// MARK: View Struct
        /// Background
        /// Step Grid
        /// Cstom Value Slider
        /// Save Buttons
        ///
        ZStack {
            ///MARK: Background
            
            
            ///MARK: View
            VStack {
                HeaderView()
                
                Divider()
                
                GridView()
                
                CustomValueView()
                
               
            }
        }
    }
    
    //MARK: ViewBuilder
    @ViewBuilder
    func HeaderView() -> some View {
        VStack() {
            Text("> set goal <".uppercased())
            
            Text("daily step target".uppercased())
        }
    }
    
    @ViewBuilder
    func GridView() -> some View {
        Text("> select dificulty <".uppercased())
    }
    
    @ViewBuilder
    func CustomValueView() -> some View {
        Text("> or custom value <".uppercased())
        
        // Value
        
        Slider(value: $sliderValue)
    }
    
    func SaveButtonsView() -> some View {
        Text("")
    }
}

#Preview {
    GoalScreen()
}
