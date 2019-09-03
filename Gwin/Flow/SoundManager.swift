//
//  SoundManager.swift
//  Gwin
//
//  Created by Hai Vu Van on 9/3/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import AVFoundation


class SoundManager{
  static let shared = SoundManager()


  var player: AVAudioPlayer?

  func playSound(name: String) {
    guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }

    do {
      if #available(iOS 10.0, *) {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      } else {
        // Fallback on earlier versions
      }
      try AVAudioSession.sharedInstance().setActive(true)

      /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
      player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

      /* iOS 10 and earlier require the following line:
       player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

      guard let player = player else { return }

      player.play()

    } catch let error {
      print(error.localizedDescription)
    }
  }

  func playBipSound(){
    if !UserDefaultManager.sharedInstance().settingSound() {
      playSound(name: "bip")
    }
  }

  func playBetSound() {
    if !UserDefaultManager.sharedInstance().settingSound() {
      playSound(name: "betchip")
    }
  }
}
