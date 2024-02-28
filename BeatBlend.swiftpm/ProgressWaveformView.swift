import DSWaveformImage
import DSWaveformImageViews
import SwiftUI

struct ProgressWaveformView: View {
    let audioURL: URL
    @ObservedObject var audioController: AudioController
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                WaveformView(audioURL: audioURL) { shape in
                    shape.fill(Color.darkGray)
                    shape.fill(.cyan).mask(alignment: .leading) {
                        Rectangle().frame(width: geometry.size.width * CGFloat(audioController.progress), height: geometry.size.height)
                    }
                }
                .frame(height: 30)
            }
        }
    }
}
