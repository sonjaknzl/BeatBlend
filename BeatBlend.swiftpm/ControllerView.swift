import SwiftUI

struct ControllerView: View {
    @State private var currentTrackIndexLeft: Int = 1
    @State private var currentTrackIndexRight: Int = 1
    
    var body: some View {
        ZStack{
            HStack(spacing: 50){
                Spacer()
                Group {
                }
                if currentTrackIndexLeft == 1 {
                    ControllerViewLeft(fileNumber: 1)
                } else if currentTrackIndexLeft == 2 {
                    ControllerViewLeft(fileNumber: 2)
                } else if currentTrackIndexLeft == 3 {
                    ControllerViewLeft(fileNumber: 3)
                }
            
                VStack{
                } 
                .frame(width: 300)
           
                Group {
                    if currentTrackIndexRight == 1 {
                        ControllerViewRight(fileNumber: 1)
                    } else if currentTrackIndexRight == 2 {
                        ControllerViewRight(fileNumber: 2)
                    } else if currentTrackIndexRight == 3 {
                        ControllerViewRight(fileNumber: 3)
                    }
                }
                Spacer()
            }
            VStack {
                Text("BeatBlend")
                    .font(.custom("AnalogueOS-Regular", size: 44))
                    .foregroundColor(.cyan)
                    .frame(width:250)
                Text("by Sonja Künzl")
                    .font(.custom("AnalogueOS-Regular", size: 16))
                    .foregroundColor(.darkGray)
                    .frame(width:250)
                    .padding(.top, 5)
                    .padding(.bottom, 100)
                
                VStack (spacing: 20) {
                    HStack{
                        Text("Track")
                            .font(.custom("AnalogueOS-Regular", size: 14))
                            .frame(width:80, alignment: .leading)
                        Text("Artist")
                            .font(.custom("AnalogueOS-Regular", size: 14))
                            .frame(width:60, alignment: .leading)
                        Text("BPM")
                            .font(.custom("AnalogueOS-Regular", size: 14))
                            .frame(width:40, alignment: .center)
                        Text("Time")
                            .font(.custom("AnalogueOS-Regular", size: 14))
                            .frame(width: 40, alignment: .trailing)
                    }
                    ForEach(1..<4, id: \.self) { index in
                        let (trackName, artist, bpm, time): (String, String, String, String) = trackInfo(forIndex: index)
                        let id: Int = index
                        TrackRow(trackName: trackName, artist: artist, bpm: bpm, time: time, id: id, currentTrackIndexLeft: $currentTrackIndexLeft, currentTrackIndexRight: $currentTrackIndexRight)
                    }
                    
                }
                .padding(20)
                .background(Color.darkerGray)
                .shadow(radius: 5)
                .frame(width:150)

            }
        }
    }
}

struct ControllerView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerView()
    }
}
