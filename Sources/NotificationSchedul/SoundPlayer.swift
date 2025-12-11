//
//  SoundPlayer.swift
//

import Foundation
import AVFoundation

public class SoundPlayer {
    public static let shared = SoundPlayer()
    private var player: AVAudioPlayer?

    public func play(_ sound: String) {
        let name = sound.replacingOccurrences(of: ".wav", with: "")
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
            print("Sound not found: \(sound)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Sound error: \(error.localizedDescription)")
        }
    }

    public func stop() {
        player?.stop()
    }
}
