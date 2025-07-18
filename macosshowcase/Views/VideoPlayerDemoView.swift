//
//  VideoPlayerDemoView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI
import AVKit
import AVFoundation

// Helper class to manage player observation
class PlayerObserver: ObservableObject {
    private var timeObserver: Any?
    @Published var currentTime: Double = 0
    
    func startObserving(player: AVPlayer) {
        stopObserving(player: player)
        
        let timeInterval = CMTime(seconds: 1.0, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: timeInterval, queue: .main) { [weak self] time in
            self?.currentTime = time.seconds.isFinite ? time.seconds : 0
        }
    }
    
    func stopObserving(player: AVPlayer) {
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
}

struct VideoPlayerDemoView: View {
    @State private var showVideoPlayer = false
    @State private var player1: AVPlayer?
    @State private var player2: AVPlayer?
    @State private var showingFileImporter = false
    @State private var selectedVideoURL: URL?
    @State private var isPlaying = false
    @State private var currentTime: Double = 0
    @State private var duration: Double = 1
    @State private var volume: Double = 0.5
    @State private var playerObserver: PlayerObserver?
    
    // Sample video URLs for demonstration
    private let sampleVideoURLs = [
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                headerSection("VideoPlayer Integration")
                
                basicVideoPlayerSection
                customControlsSection
                videoFileImportSection
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("VideoPlayer Demo")
        .fileImporter(
            isPresented: $showingFileImporter,
            allowedContentTypes: [.movie, .video],
            allowsMultipleSelection: false
        ) { result in
            handleVideoImport(result)
        }
        .onAppear {
            setupPlayers()
        }
        .onDisappear {
            cleanupPlayer()
        }
    }
    
    private var basicVideoPlayerSection: some View {
        demoSection("Custom VideoPlayer (AVPlayerLayer)") {
            VStack(spacing: 20) {
                if showVideoPlayer {
                    GroupBox("Custom VideoPlayer with AVPlayerLayer") {
                        VStack(spacing: 15) {
                            if let player1 = player1 {
                                VStack(spacing: 10) {
                                    CustomVideoPlayerView(player: player1)
                                        .frame(height: 200)
                                        .cornerRadius(12)
                                    
                                    CustomVideoPlayerControls(player: player1)
                                }
                            } else {
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(height: 200)
                                    .cornerRadius(12)
                                    .overlay(
                                        Text("Initializing Player...")
                                            .foregroundColor(.white)
                                    )
                            }
                            
                            HStack {
                                Button("Load Sample Video") {
                                    loadSampleVideo()
                                }
                                .buttonStyle(.borderedProminent)
                                
                                Spacer()
                                
                                Button("Stop & Reset") {
                                    player1?.pause()
                                    player1?.seek(to: .zero)
                                }
                            }
                            
                            Text("Custom VideoPlayer using AVPlayerLayer (bypasses SwiftUI VideoPlayer crashes)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    GroupBox("Multiple Player Support") {
                        VStack(spacing: 15) {
                            if let player2 = player2 {
                                VStack(spacing: 10) {
                                    CustomVideoPlayerView(player: player2)
                                        .frame(height: 150)
                                        .cornerRadius(8)
                                    
                                    HStack {
                                        Button("Play") {
                                            player2.play()
                                        }
                                        
                                        Button("Pause") {
                                            player2.pause()
                                        }
                                        
                                        Button("Restart") {
                                            player2.seek(to: .zero)
                                            player2.play()
                                        }
                                    }
                                }
                            } else {
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(height: 150)
                                    .cornerRadius(8)
                                    .overlay(
                                        Text("Secondary Player")
                                            .foregroundColor(.white)
                                    )
                            }
                            
                            Text("Secondary video player instance with basic controls")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } else {
                    GroupBox("Custom VideoPlayer Initialization") {
                        VStack(spacing: 15) {
                            Text("🎥 Custom VideoPlayer Ready")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text("This implementation uses AVPlayerLayer directly instead of SwiftUI's VideoPlayer to avoid metadata initialization crashes in _AVKit_SwiftUI framework.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button("Initialize Custom VideoPlayer") {
                                initializeVideoPlayer()
                            }
                            .buttonStyle(.borderedProminent)
                            
                            Text("✅ Safe: Uses AVFoundation directly without problematic SwiftUI VideoPlayer")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    private var customControlsSection: some View {
        demoSection("Advanced Features") {
            VStack(spacing: 20) {
                GroupBox("Playback Rate Control") {
                    VStack(spacing: 15) {
                        Text("Adjust playback speed")
                            .font(.headline)
                        
                        HStack {
                            Button("0.5x") {
                                player1?.rate = 0.5
                            }
                            
                            Button("1.0x") {
                                player1?.rate = 1.0
                            }
                            
                            Button("1.5x") {
                                player1?.rate = 1.5
                            }
                            
                            Button("2.0x") {
                                player1?.rate = 2.0
                            }
                        }
                        
                        Text("Control video playback speed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Player Information") {
                    VStack(spacing: 10) {
                        if let player = player1,
                           let currentItem = player.currentItem {
                            
                            HStack {
                                Text("Status:")
                                Spacer()
                                Text(playerStatusText(for: currentItem.status))
                                    .foregroundColor(currentItem.status == .readyToPlay ? .green : .orange)
                            }
                            
                            if let asset = currentItem.asset as? AVURLAsset {
                                HStack {
                                    Text("Source:")
                                    Spacer()
                                    Text(asset.url.lastPathComponent)
                                        .truncationMode(.middle)
                                }
                            }
                            
                            HStack {
                                Text("Rate:")
                                Spacer()
                                Text(String(format: "%.1fx", player.rate))
                            }
                            
                        } else {
                            Text("No player loaded")
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Real-time player status information")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private func playerStatusText(for status: AVPlayerItem.Status) -> String {
        switch status {
        case .readyToPlay:
            return "Ready to Play"
        case .failed:
            return "Failed"
        case .unknown:
            return "Loading..."
        @unknown default:
            return "Unknown"
        }
    }
    
    private var videoFileImportSection: some View {
        demoSection("Video File Import") {
            VStack(spacing: 20) {
                GroupBox("Import Local Videos") {
                    VStack(spacing: 15) {
                        if let videoURL = selectedVideoURL {
                            Text("Selected: \(videoURL.lastPathComponent)")
                                .font(.headline)
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                        }
                        
                        Button("Import Video File") {
                            showingFileImporter = true
                        }
                        .buttonStyle(.borderedProminent)
                        
                        if selectedVideoURL != nil {
                            Button("Play Selected Video") {
                                playSelectedVideo()
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        Text("Import and play local video files using file picker")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Sample Videos") {
                    VStack(spacing: 15) {
                        Text("Load sample videos from web:")
                            .font(.headline)
                        
                        ForEach(Array(sampleVideoURLs.enumerated()), id: \.offset) { index, urlString in
                            Button("Sample Video \(index + 1)") {
                                loadVideoFromURL(urlString)
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        Text("Sample videos for testing (requires internet connection)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func setupPlayers() {
        // Initialize players on the main thread with delay to avoid metadata initialization issues
        DispatchQueue.main.async {
            self.player1 = AVPlayer()
            self.player2 = AVPlayer()
            self.playerObserver = PlayerObserver()
            
            // Set up player 1 after a brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let player1 = self.player1 {
                    self.playerObserver?.startObserving(player: player1)
                }
            }
        }
    }
    
    private func cleanupPlayer() {
        // Remove time observer
        if let player1 = player1 {
            playerObserver?.stopObserving(player: player1)
        }
        
        // Stop accessing security-scoped resource
        if let url = selectedVideoURL {
            url.stopAccessingSecurityScopedResource()
        }
        
        // Pause players
        player1?.pause()
        player2?.pause()
        
        // Remove notification observers
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadSampleVideo() {
        guard let player1 = player1, let url = URL(string: sampleVideoURLs[0]) else { return }
        let playerItem = AVPlayerItem(url: url)
        player1.replaceCurrentItem(with: playerItem)
        
        // Update duration when item is ready using modern API
        Task {
            do {
                let duration = try await playerItem.asset.load(.duration)
                await MainActor.run {
                    self.duration = duration.seconds.isFinite ? duration.seconds : 1.0
                }
            } catch {
                await MainActor.run {
                    self.duration = 1.0
                }
            }
        }
    }
    
    private func loadVideoFromURL(_ urlString: String) {
        guard let player1 = player1, let player2 = player2, let url = URL(string: urlString) else { return }
        let playerItem1 = AVPlayerItem(url: url)
        let playerItem2 = AVPlayerItem(url: url)
        
        player1.replaceCurrentItem(with: playerItem1)
        player2.replaceCurrentItem(with: playerItem2)
        
        // Update duration
        Task {
            do {
                let duration = try await playerItem1.asset.load(.duration)
                await MainActor.run {
                    self.duration = duration.seconds.isFinite ? duration.seconds : 1.0
                }
            } catch {
                await MainActor.run {
                    self.duration = 1.0
                }
            }
        }
    }
    
    private func handleVideoImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            
            // Start accessing security-scoped resource
            _ = url.startAccessingSecurityScopedResource()
            
            selectedVideoURL = url
            
            // Stop accessing the resource when done (you'd typically do this in a cleanup method)
            // url.stopAccessingSecurityScopedResource()
            
        case .failure(let error):
            print("Failed to import video: \(error)")
        }
    }
    
    private func playSelectedVideo() {
        guard let player1 = player1, let url = selectedVideoURL else { return }
        let playerItem = AVPlayerItem(url: url)
        player1.replaceCurrentItem(with: playerItem)
        
        // Update duration
        Task {
            do {
                let duration = try await playerItem.asset.load(.duration)
                await MainActor.run {
                    self.duration = duration.seconds.isFinite ? duration.seconds : 1.0
                    player1.play()
                    self.isPlaying = true
                }
            } catch {
                await MainActor.run {
                    self.duration = 1.0
                    player1.play()
                    self.isPlaying = true
                }
            }
        }
    }
    
    private func togglePlayPause() {
        guard let player1 = player1 else { return }
        if isPlaying {
            player1.pause()
        } else {
            player1.play()
        }
        isPlaying.toggle()
    }
    
    private func seekBackward() {
        guard let player1 = player1 else { return }
        let currentTime = player1.currentTime()
        let newTime = CMTimeSubtract(currentTime, CMTime(seconds: 10, preferredTimescale: 600))
        let clampedTime = CMTimeMaximum(newTime, .zero)
        player1.seek(to: clampedTime)
    }
    
    private func seekForward() {
        guard let player1 = player1 else { return }
        let currentTime = player1.currentTime()
        let newTime = CMTimeAdd(currentTime, CMTime(seconds: 10, preferredTimescale: 600))
        player1.seek(to: newTime)
    }
    
    private func initializeVideoPlayer() {
        showVideoPlayer = true
        
        // Initialize players with a slight delay to allow UI to update
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            loadSampleVideo()
        }
    }
    
    private func demoSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            content()
        }
    }
    
    private func headerSection(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("VideoPlayer integration with custom controls and file import")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        VideoPlayerDemoView()
    }
}
