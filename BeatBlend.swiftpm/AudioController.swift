import AVFoundation
import SwiftUI

class AudioController: ObservableObject {
    var fileNumber: Int
    private let engine = AVAudioEngine()
    private let mixer = AVAudioMixerNode()
    @Published var highsPlayer = AVAudioPlayerNode()
    @Published var midsPlayer = AVAudioPlayerNode()
    @Published var lowsPlayer = AVAudioPlayerNode()
    var pitchNode = AVAudioUnitTimePitch()
    private let bpm: Float
    var currentBPM: Float
    @Published var rate: Float = 1
    private var sampleRateSong: Double = 0
    private var startInSongSeconds: Double = 0
    private var lengthSongSeconds: Double = 0
    private var songLengthSamples: AVAudioFramePosition!
    private var timer: Timer?
    @Published var progress: Double = 0
    var progressUpdateHandler: ((Double) -> Void)?
    var lastRenderSampleTime: AVAudioFramePosition = 0
    @Published var isPlaying: Bool = false
    var elapsedTime: Double = 0
    private var lastUpdateTime: Date = Date()
    
    let highsURL: URL!
    let midsURL: URL!
    let lowsURL: URL!
    
    var highsFile: AVAudioFile
    var midsFile: AVAudioFile
    var lowsFile: AVAudioFile
    
    init(fileNumber: Int) {
        self.fileNumber = fileNumber
        let (trackName, artist, bpm, time) = trackInfo(forIndex: self.fileNumber)
        self.bpm = Float(bpm)!
        self.currentBPM = Float(bpm)!
        
        let lowsFileName = "\(fileNumber)-lows"
        lowsURL = Bundle.main.url(forResource: lowsFileName, withExtension: "mp3")!
        lowsFile = try! AVAudioFile(forReading: lowsURL)
        
        let midsFileName = "\(fileNumber)-mids"
        midsURL = Bundle.main.url(forResource: midsFileName, withExtension: "mp3")!
        midsFile = try! AVAudioFile(forReading: midsURL)
        
        let highsFileName = "\(fileNumber)-highs"
        highsURL = Bundle.main.url(forResource: highsFileName, withExtension: "mp3")!
        highsFile = try! AVAudioFile(forReading: highsURL)

        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        engine.attach(highsPlayer)
        engine.attach(midsPlayer)
        engine.attach(lowsPlayer)
        engine.attach(pitchNode)
        engine.attach(mixer)
        
        engine.connect(highsPlayer, to: mixer, format: nil)
        engine.connect(midsPlayer, to: mixer, format: nil)
        engine.connect(lowsPlayer, to: mixer, format: nil)
        engine.connect(mixer, to: pitchNode, format: nil)
        engine.connect(pitchNode, to: engine.mainMixerNode, format: nil)
            
        songLengthSamples = highsFile.length
        let songFormat = highsFile.processingFormat
        sampleRateSong = songFormat.sampleRate
        
        lengthSongSeconds = Double(songLengthSamples) / sampleRateSong
        
        
        scheduleFilesForPlayer()
        
        try! engine.start()
    }
    
    func startPlayer() {
        if(progress >= 1){
            progress = 0
            elapsedTime = 0
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.updateProgress()
        }
        lastUpdateTime = Date()
        
        let outputFormat = highsPlayer.outputFormat(forBus: 0)
        let kStartDelayTime: TimeInterval = 0.0 
        let startSampleTime = highsPlayer.lastRenderTime?.sampleTime ?? 0 
        let startTime = AVAudioTime(sampleTime: startSampleTime + AVAudioFramePosition(kStartDelayTime * outputFormat.sampleRate), atRate: outputFormat.sampleRate)
        
        highsPlayer.play(at: startTime)
        midsPlayer.play(at: startTime)
        lowsPlayer.play(at: startTime) 
    
        isPlaying = true
    }
    
    func pausePlayer() {
        timer?.invalidate()
        timer = nil
        
        highsPlayer.pause()
        midsPlayer.pause()
        lowsPlayer.pause()
        
        isPlaying = false
    }
    
    func stopPlayer() {
        highsPlayer.stop()
        midsPlayer.stop()
        lowsPlayer.stop()
        
        timer?.invalidate()
        timer = nil
        
        if(progress >= 1){
            progress = 1
        } else {
            progress = 0
            elapsedTime = 0
        }
        scheduleFilesForPlayer()
        isPlaying = false
    }
    
    func setHighsVolume(_ volume: Float) {
        highsPlayer.volume = volume 
    }
    
    func setMidsVolume(_ volume: Float) {
        midsPlayer.volume = volume
    }
    
    func setLowsVolume(_ volume: Float) {
        lowsPlayer.volume = volume
    }
    
    func recalculateBPM(withRate rate: Float) {
        self.rate = rate
        pitchNode.rate = rate
        currentBPM = bpm * rate
    }
    

    
    func updateProgress() {
        if self.highsPlayer.isPlaying {
            let currentTime = Date()
            let timeSinceLastUpdate = currentTime.timeIntervalSince(lastUpdateTime) 
            elapsedTime += timeSinceLastUpdate*Double(self.rate)

            progress = elapsedTime/lengthSongSeconds
            if(progress>=1){
                stopPlayer()
            }
            progressUpdateHandler?(progress)
            lastUpdateTime = currentTime
        }
    }
    
    private func scheduleFilesForPlayer() {
        let outputFormat = highsPlayer.outputFormat(forBus: 0)
        let startTime = AVAudioTime(sampleTime: AVAudioFramePosition(0), atRate: outputFormat.sampleRate)
        highsPlayer.scheduleFile(highsFile, at: startTime)
        
        highsPlayer.scheduleFile(highsFile, at: startTime)
        midsPlayer.scheduleFile(midsFile, at: startTime)
        lowsPlayer.scheduleFile(lowsFile, at: startTime)
        
        let frameCountHighs: AVAudioFrameCount = AVAudioFrameCount(songLengthSamples)
        highsPlayer.prepare(withFrameCount: frameCountHighs)
        midsPlayer.prepare(withFrameCount: frameCountHighs)
        lowsPlayer.prepare(withFrameCount: frameCountHighs)
    }
}
