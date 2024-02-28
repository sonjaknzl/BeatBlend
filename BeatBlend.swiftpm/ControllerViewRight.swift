import SwiftUI
import AVFoundation

struct ControllerViewRight: View {
    @StateObject var audioController: AudioController
    @State private var rotationAngle: Angle = .degrees(0)
    @GestureState private var isDetectingLongPress = false
    var fileNumber: Int 
    
    init(fileNumber: Int) {
        self.fileNumber = fileNumber
        _audioController = StateObject(wrappedValue: AudioController(fileNumber: fileNumber))
    }
    
    var body: some View {
        
        let (trackName, artist, bpm, time) = trackInfo(forIndex: audioController.fileNumber)
        VStack (spacing: 20) {
            
            VStack(spacing: 15){
                Text("\(trackName)")
                    .font(.custom("AnalogueOS-Regular", size: 24))
                    .foregroundColor(.cyan) 
                Text("\(artist)")
                    .font(.custom("AnalogueOS-Regular", size: 14))
                    .foregroundColor(Color.darkGray) 
                ProgressWaveformView(audioURL: Bundle.main.url(forResource: "\(fileNumber)-highs", withExtension: "mp3")!, audioController: audioController)
                    .frame(width: 250)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .frame(height: 60)
                HStack{
                    Text("BPM: \(Int(audioController.currentBPM))")
                        .font(.custom("AnalogueOS-Regular", size: 18))
                        .padding(.leading, 25)
                    Spacer()
                    Text("Time: \(timeString(from: audioController.elapsedTime))")
                        .font(.custom("AnalogueOS-Regular", size: 18))
                        .padding(.trailing, 25)
                        .frame(width: 105, alignment: .leading)
                }
            }
            .frame(width: 300) 
            .padding()
            .background(Color.darkerGray)
            .cornerRadius(20)
            .shadow(radius: 5)
            HStack(alignment: .center, spacing: 30){
                VStack (spacing: 10) {
                    CircularSliderView(volume: $audioController.highsPlayer.volume)
                    Text("highs")
                        .font(.custom("AnalogueOS-Regular", size: 18))
                        .foregroundColor(Color.darkGray)
                        .padding(.bottom, 25)
                    CircularSliderView(volume: $audioController.midsPlayer.volume)
                    Text("mids")
                        .font(.custom("AnalogueOS-Regular", size: 18))
                        .foregroundColor(Color.darkGray)
                        .padding(.bottom, 25)
                    CircularSliderView(volume: $audioController.lowsPlayer.volume)
                    Text("lows")
                        .font(.custom("AnalogueOS-Regular", size: 18))
                        .foregroundColor(Color.darkGray)
                }
                
                ZStack (alignment: .topLeading) {
                    Image("shadow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 235, height: 230)
                    
                    Button(action: {
                        audioController.startPlayer()
                    }) {
                        
                        Image("disk")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 230, height: 230)
                            .rotationEffect(rotationAngle)
                        
                        
                    }
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.2)
                            .onChanged { pressing in
                                if pressing {
                                    audioController.pausePlayer() 
                                }
                            }
                    )
                }
            }
            .padding(.top, 40)
            HStack (spacing: 30){
                VStack () {
                    Button(action: {
                        if audioController.isPlaying {
                            audioController.pausePlayer() 
                        } else {
                            audioController.startPlayer() 
                        }
                    }) {
                        Image("play")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                    Button(action: {
                        audioController.stopPlayer()
                    }) {
                        Image("stop")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                }
                
                
                VerticalSliderView(value: $audioController.rate, range: 0.75...1.25)
                    .onChange(of: audioController.rate) { newRate in
                        audioController.recalculateBPM(withRate: newRate)
                    }
            }
            Spacer()
        }
        .frame(width: 330)
        .padding(.top, 30)
        .onReceive(audioController.$isPlaying) { playing in
            if playing {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    rotationAngle = .degrees(360)
                }
            } else {
                withAnimation(Animation.easeOut(duration: 1)){
                    rotationAngle = .degrees(0)
                }
            }
            
        }
        .padding(.top, 40)
        .padding(.bottom, 40)
    }
    
    func timeString(from timeInterval: Double) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

