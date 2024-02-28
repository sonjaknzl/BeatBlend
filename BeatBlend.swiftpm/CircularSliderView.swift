import SwiftUI

struct CircularSliderView: View {
    @Binding var volume: Float
    @State private var knobValue: CGFloat = 0.0
    @State var angleValue: CGFloat = 0.0
    let config = Config(minimumValue: -10.0,
                        maximumValue: 10.0,
                        totalValue: 30.0,
                        knobRadius: 10.0,
                        radius: 30.0)
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.darkerGray)
                .frame(width: config.radius * 2, height: config.radius * 2)
                .scaleEffect(1.2)
                
            
            Circle()
                .stroke(Color.darkGray,
                        style: StrokeStyle(lineWidth: 3, lineCap: .butt, dash: [3, 12.7]))
                .frame(width: config.radius * 1.5, height: config.radius * 1.5)
            
            Circle()
                .trim(from: 0.0, to: knobValue/config.totalValue)
                .stroke(Color.darkGray, lineWidth: 4)
                .frame(width: config.radius * 1.5, height: config.radius * 1.5)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .trim(from: 0.0, to: -knobValue/config.totalValue)
                .stroke(Color.darkGray, lineWidth: 4)
                .frame(width: config.radius * 1.5, height: config.radius * 1.5)
                .rotationEffect(.degrees(90))
                .scaleEffect(x: 1, y: -1) // Mirroring vertically
            
            Circle()
                .fill(Color.darkGray)
                .frame(width: config.knobRadius * 1.5, height: config.knobRadius * 1.5)
                .padding(10)
                .offset(y: -config.radius/1.4)
                .rotationEffect(Angle.degrees(Double(angleValue))) 
                .gesture(DragGesture(minimumDistance: 0.0)
                    .onChanged({ value in
                        change(location: value.location)
                    }))
        }
    }
    
    private func change(location: CGPoint) {
        let vector = CGVector(dx: location.x, dy: location.y)
        var angle = atan2(vector.dy - (config.knobRadius + 10), vector.dx - (config.knobRadius + 10))
    
        if angle > .pi / 2.0 {
            angle -= .pi * 2.0
        }
        let value = (angle + .pi / 2.0) / (.pi * 2.0) * config.totalValue
        
        if value >= config.minimumValue && value <= config.maximumValue {
            knobValue = CGFloat(value)
            let adjustedValue = round((Float(knobValue) - Float(config.minimumValue)) / (Float(config.maximumValue) - Float(config.minimumValue)) / 0.1) * 0.1
            volume = max(min(adjustedValue, 1.0), 0.0)
            angleValue = (angle + .pi / 2) * 180 / .pi 
        }
    }
}

struct Config {
    let minimumValue: CGFloat
    let maximumValue: CGFloat
    let totalValue: CGFloat
    let knobRadius: CGFloat 
    let radius: CGFloat
}
