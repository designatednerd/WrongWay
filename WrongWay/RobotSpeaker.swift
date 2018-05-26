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

class RobotSpeaker {
  
  private lazy var synthesizer = AVSpeechSynthesizer()
  
  func speak(text: String, accent: EnglishAccent = .british) {
    let utterance = AVSpeechUtterance(string: text)
    utterance.voice = AVSpeechSynthesisVoice(language: accent.rawValue)
    synthesizer.speak(utterance)
  }
  
}
