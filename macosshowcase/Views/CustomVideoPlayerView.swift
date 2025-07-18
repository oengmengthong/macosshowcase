import SwiftUI
import AVFoundation
import AVKit

// Custom VideoPlayer implementation using AVPlayerLayer to avoid _AVKit_SwiftUI crashes
struct CustomVideoPlayerView: NSViewRepresentable {
    let player: AVPlayer?
    
    func makeNSView(context: Context) -> CustomVideoPlayerNSView {
        return CustomVideoPlayerNSView()
    }
    
    func updateNSView(_ nsView: CustomVideoPlayerNSView, context: Context) {
        nsView.setPlayer(player)
    }
}

class CustomVideoPlayerNSView: NSView {
    private var playerLayer: AVPlayerLayer?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupPlayerLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlayerLayer()
    }
    
    private func setupPlayerLayer() {
        wantsLayer = true
        
        let playerLayer = AVPlayerLayer()
        playerLayer.videoGravity = .resizeAspect
        playerLayer.backgroundColor = NSColor.black.cgColor
        
        layer?.addSublayer(playerLayer)
        self.playerLayer = playerLayer
    }
    
    func setPlayer(_ player: AVPlayer?) {
        playerLayer?.player = player
    }
    
    override func layout() {
        super.layout()
        playerLayer?.frame = bounds
    }
    
    override var intrinsicContentSize: NSSize {
        return NSSize(width: 480, height: 270) // 16:9 aspect ratio
    }
}

// Custom video player controls
struct CustomVideoPlayerControls: View {
    let player: AVPlayer?
    @State private var isPlaying = false
    @State private var currentTime: Double = 0
    @State private var duration: Double = 0
    @State private var volume: Float = 1.0
    
    var body: some View {
        VStack(spacing: 12) {
            // Time slider
            HStack {
                Text(timeString(from: currentTime))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Slider(value: $currentTime, in: 0...max(duration, 1)) { editing in
                    if !editing {
                        let time = CMTime(seconds: currentTime, preferredTimescale: 600)
                        player?.seek(to: time)
                    }
                }
                .disabled(player == nil)
                
                Text(timeString(from: duration))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Control buttons
            HStack(spacing: 20) {
                Button(action: seekBackward) {
                    Image(systemName: "gobackward.10")
                        .font(.title2)
                }
                .disabled(player == nil)
                
                Button(action: togglePlayPause) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.title)
                }
                .disabled(player == nil)
                
                Button(action: seekForward) {
                    Image(systemName: "goforward.10")
                        .font(.title2)
                }
                .disabled(player == nil)
                
                Spacer()
                
                // Volume control
                HStack {
                    Image(systemName: volume > 0.5 ? "speaker.2.fill" : volume > 0 ? "speaker.1.fill" : "speaker.slash.fill")
                        .foregroundColor(.secondary)
                    
                    Slider(value: Binding(
                        get: { Double(volume) },
                        set: { volume = Float($0); player?.volume = volume }
                    ), in: 0...1)
                    .frame(width: 80)
                }
            }
        }
        .onAppear {
            setupTimeObserver()
            updatePlayerInfo()
        }
        .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
            isPlaying = false
        }
    }
    
    private func togglePlayPause() {
        guard let player = player else { return }
        
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
    
    private func seekBackward() {
        guard let player = player else { return }
        let currentTime = player.currentTime()
        let newTime = CMTimeSubtract(currentTime, CMTime(seconds: 10, preferredTimescale: 600))
        let clampedTime = CMTimeMaximum(newTime, .zero)
        player.seek(to: clampedTime)
    }
    
    private func seekForward() {
        guard let player = player else { return }
        let currentTime = player.currentTime()
        let newTime = CMTimeAdd(currentTime, CMTime(seconds: 10, preferredTimescale: 600))
        player.seek(to: newTime)
    }
    
    private func setupTimeObserver() {
        guard let player = player else { return }
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak player] time in
            guard let player = player else { return }
            
            self.currentTime = time.seconds
            self.isPlaying = player.rate > 0
        }
    }
    
    private func updatePlayerInfo() {
        guard let player = player,
              let currentItem = player.currentItem else { return }
        
        if currentItem.duration.isValid && !currentItem.duration.isIndefinite {
            self.duration = currentItem.duration.seconds
        }
        
        self.volume = player.volume
        self.isPlaying = player.rate > 0
    }
    
    private func timeString(from seconds: Double) -> String {
        guard !seconds.isNaN && !seconds.isInfinite else { return "0:00" }
        
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let remainingSeconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}
