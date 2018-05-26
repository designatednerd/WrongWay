//
//  Discouragements.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import Foundation

struct Discouragement {
  
  static let thingsToSay = [
    "Wrong way, dingus.",
    "Your destination is not this way, dipshit.",
    "Nope, not it, fuckstick.",
    "Turn around, moron.",
    "You have literally no sense of direction.",
    "You suck. Turn around.",
    "You are directionless, just like your life.",
    "Not this way, nincompoop.",
  ]
  
  static var random: String {
    let randomIndex = Int(arc4random_uniform(UInt32(thingsToSay.count)))
    return thingsToSay[randomIndex]
  }
}
