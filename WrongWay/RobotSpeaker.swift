//
//  RobotSpeaker.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import UIKit
import AVKit

enum EnglishAccent: String {
  case american = "en-US"
  case australian = "en-AU"
  case british = "en-GB"
  case irish = "en-IE"
  case southAfrican = "en-ZA"
}

class RobotSpeaker: NSObject {

  let synthesizer: AVSpeechSynthesizer

  override init() {
    self.synthesizer = AVSpeechSynthesizer()
    super.init()
    
    self.synthesizer.delegate = self
  }
  
  private var enqueuedUtterances = [AVSpeechUtterance]()
  
  func speak(text: String, accent: EnglishAccent = .american) {
    let utterance = AVSpeechUtterance(string: text)
    utterance.voice = AVSpeechSynthesisVoice(language: accent.rawValue)
    self.enqueuedUtterances.append(utterance)
    guard !synthesizer.isSpeaking else {
      // we'll start when it shuts up
      return
    }
    
    self.speakNext()
  }
  
  private func speakNext() {
    guard !enqueuedUtterances.isEmpty else {
      // Nothing more to say
      return
    }
    
    let nextUtterance = enqueuedUtterances.removeFirst()
    synthesizer.speak(nextUtterance)
  }
}

extension RobotSpeaker: AVSpeechSynthesizerDelegate {
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    self.speakNext()
  }
}
