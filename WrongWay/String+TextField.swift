//
//  String+TextField.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import UIKit

extension String {
  
  static func proposed(from textField: UITextField,
                       changingCharactersIn range: NSRange,
                       replacementString string: String) -> String {
    let text = (textField.text ?? "") as NSString
    let proposed = text.replacingCharacters(in: range, with: string)
    return proposed
  }
}
