import SwiftUI

struct VerticalSliderView: View {
    @Binding var value: Float
    var range: ClosedRange<Float>
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.darkerGray)
                    .frame(width: 15, height: 150)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.darkGray)
                    .frame(width: 50, height: 30)
                    .offset(x: 0, y: CGFloat(mapValueToY()))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let sliderHeight = 150.0
                                let newY = max(0, min(sliderHeight, gesture.location.y)) 
                                let totalRange = range.upperBound - range.lowerBound
                                let newValue = range.lowerBound + (Float(newY/sliderHeight)) * totalRange
                                self.value = min(max(self.range.lowerBound, newValue), self.range.upperBound)
                            }
                    )
                VStack {
                    Text("BPM")
                        .font(.custom("AnalogueOS-Regular", size: 18))
                        .foregroundColor(Color.darkGray)
                        .padding(.top, 170)
                }
            }
        }
    }
    
    func mapValueToY() -> Float {
        let sliderHeight: Float = 150.0
        let totalRange = range.upperBound - range.lowerBound
        let valueOffset = value - range.lowerBound
        let valueRatio = valueOffset / totalRange
        let yValue = sliderHeight * Float(valueRatio)
        let adjustedYValue = yValue - 15
        return Float(adjustedYValue)
    }
}
