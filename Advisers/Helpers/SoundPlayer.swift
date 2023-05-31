//
//  SoundPlayer.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/23.
//

import AppKit
import AVFoundation

class SoundPlayer {
    
    static let shared = SoundPlayer()
    
    private init() {}
    
    private var player: AVAudioPlayer?
    
    func playOneShot(_ name: String, type: String) {
        guard let asset = NSDataAsset(name: name) else {
            return
        }
        
        do {
            player = try AVAudioPlayer(data: asset.data, fileTypeHint: type)
            player?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func playRingtone() {
        playOneShot("Ringtone", type: "mp3")
    }
}
