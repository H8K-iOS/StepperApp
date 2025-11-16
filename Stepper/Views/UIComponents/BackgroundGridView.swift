import SwiftUI

struct BackgroundGridView: View {
    let spacing: Int
    let lineColor: Color = Color.white.opacity(0.1)
    
    var body: some View {
        Canvas { cntxt, size in
            var path = Path()
            
            for x in stride(from: 0, to: size.width, by: CGFloat.Stride(spacing)) {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
            }
            
            for y in stride(from: 0, to: size.height, by: CGFloat.Stride(spacing)) {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
            }
            
            cntxt.stroke(path, with: .color(lineColor), lineWidth: 1)
        }
        .ignoresSafeArea()
    }
}

