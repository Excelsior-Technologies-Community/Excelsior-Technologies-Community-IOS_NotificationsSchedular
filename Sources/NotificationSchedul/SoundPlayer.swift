//
//  SoundPlayer.swift
//  NotificationSchedul
//
//  Created by Noman belim on 07/12/25.
//

import Foundation
import AVFoundation

public class SoundPlayer {
    static let shared = SoundPlayer()
    private var player: AVAudioPlayer?

    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName.replacingOccurrences(of: ".wav", with: ""), withExtension: "wav") else {
            print("Sound not found: \(soundName)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }

    func stop() {
        player?.stop()
    }
}
