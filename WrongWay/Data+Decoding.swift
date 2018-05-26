//
//  Data+Decoding.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import Foundation

extension Data {
  
  func decode<T: Decodable>() -> T? {
    let decoder = JSONDecoder()
    do {
      let result = try decoder.decode(T.self, from: self)
      return result
    } catch let error {
      NSLog("Error: \(error)")
      return nil
    }
  }
  
  func toString() -> String? {
    return String(data: self, encoding: .utf8)
  }
}
