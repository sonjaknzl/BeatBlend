import SwiftUI

struct TrackRow: View {
    let trackName: String
    let artist: String
    let bpm: String
    let time: String
    let id: Int
    @State private var draggedOffset: CGSize = .zero
    @Binding var currentTrackIndexLeft: Int
    @Binding var currentTrackIndexRight: Int
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 1)
                .frame(width: 260)
                .foregroundColor(Color.darkGray)
                .padding(0)
            HStack (alignment: .top){
                Text("\(trackName)")
                    .font(.custom("AnalogueOS-Regular", size: 14))
                    .frame(width:80, alignment: .leading)
                Text("\(artist)")
                    .font(.custom("AnalogueOS-Regular", size: 14))
                    .frame(width:60, alignment: .leading)
                Text("\(bpm)")
                    .font(.custom("AnalogueOS-Regular", size: 14))
                    .frame(width:40, alignment: .center)
                Text("\(time)")
                    .font(.custom("AnalogueOS-Regular", size: 14))
                    .frame(width: 40, alignment: .trailing)
            }
        }
        .padding(0)
        .frame(height: 40)
        .background(Color.darkGray)
        .cornerRadius(5)
        .offset(draggedOffset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    draggedOffset = gesture.translation

                    
                }
                .onEnded { gesture in
                    let location = gesture.location
                    let controllerViewRectLeft = CGRect(x: -400, y: -500, width: 300, height: 1000)
                    let controllerViewRectRight = CGRect(x: 400, y: -500, width: 300, height: 1000)
                      
                    
                    if controllerViewRectLeft.contains(location) {
                        self.currentTrackIndexLeft = self.id
                    }
                    if controllerViewRectRight.contains(location) {
                        self.currentTrackIndexRight = self.id
                    }
                    draggedOffset = .zero
                }
            
        )
    }
}
