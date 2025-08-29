//
// Audio Manager for Gomoku Game
//

import Foundation
import AVFoundation

@MainActor
class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    private var backgroundPlayer: AVAudioPlayer?
    private var soundEffectPlayers: [AVAudioPlayer] = []
    
    @Published var isSoundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isSoundEnabled, forKey: "soundEnabled")
            if !isSoundEnabled {
                stopBackgroundMusic()
            } else {
                playBackgroundMusic()
            }
        }
    }
    
    private init() {
        self.isSoundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    // MARK: - Background Music
    
    func playBackgroundMusic() {
        guard isSoundEnabled else { return }
        
        if backgroundPlayer?.isPlaying == true { return }
        
        guard let url = Bundle.main.url(forResource: "background", withExtension: "mp3") else {
            print("Background music file not found")
            return
        }
        
        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = -1 // Loop indefinitely
            backgroundPlayer?.volume = 0.6
            backgroundPlayer?.play()
        } catch {
            print("Failed to play background music: \(error)")
        }
    }
    
    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
        backgroundPlayer = nil
    }
    
    func pauseBackgroundMusic() {
        backgroundPlayer?.pause()
    }
    
    func resumeBackgroundMusic() {
        guard isSoundEnabled else { return }
        backgroundPlayer?.play()
    }
    
    // MARK: - Sound Effects
    
    func playSoundEffect(_ soundName: String, volume: Float = 0.8) {
        guard isSoundEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Sound effect file not found: \(soundName)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.play()
            
            // Keep reference to prevent deallocation during playback
            soundEffectPlayers.append(player)
            
            // Remove from array after playback completes
            DispatchQueue.main.asyncAfter(deadline: .now() + player.duration + 0.1) { [weak self] in
                self?.soundEffectPlayers.removeAll { $0 == player }
            }
        } catch {
            print("Failed to play sound effect \(soundName): \(error)")
        }
    }
    
    // MARK: - Game-Specific Sound Effects
    
    func playButtonTap() {
        playSoundEffect("buttonTap", volume: 0.6)
    }
    
    func playStonePlacement() {
        playSoundEffect("buttonTap", volume: 0.4) // Using buttonTap for stone placement
    }
    
    func playGameStart() {
        playSoundEffect("gameStart", volume: 1.0)
    }
    
    func playWin() {
        playSoundEffect("win", volume: 0.8)
    }
    
    func playLose() {
        playSoundEffect("lose", volume: 0.8)
    }
    
    func playTie() {
        playSoundEffect("win", volume: 0.8)
    }
    
    // MARK: - Cleanup
    
    func cleanup() {
        stopBackgroundMusic()
        soundEffectPlayers.removeAll()
    }
}
