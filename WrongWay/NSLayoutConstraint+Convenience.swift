//
//  NSLayoutConstraint+Convenience.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import UIKit

extension UIView {
  
  var unwrappedSuperview: UIView {
    guard let superview = self.superview else {
      fatalError("Don't call before in a superview")
    }
    
    return superview
  }
  
  func edgesToSuperview() -> [NSLayoutConstraint] {
    let unwrapped = self.unwrappedSuperview
    return [
      self.top(to: unwrapped),
      self.leading(to: unwrapped),
      self.bottom(to: unwrapped),
      self.trailing(to: unwrapped),
    ]
  }
  
  func topToSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
    return self.top(to: self.unwrappedSuperview, constant: constant)
  }
  
  func top(to otherView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
    return self.topAnchor.constraint(equalTo: otherView.topAnchor, constant: constant)
  }
  
  func leadingToSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
    return self.leading(to: self.unwrappedSuperview, constant: constant)
  }
  
  func leading(to otherView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
    return self.leadingAnchor.constraint(equalTo: otherView.leadingAnchor, constant: constant)
  }
  
  func bottomToSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
    return self.bottom(to: self.unwrappedSuperview, constant: constant)
  }
  
  func bottom(to otherView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
    return self.bottomAnchor.constraint(equalTo: otherView.bottomAnchor, constant: constant)
  }
  
  func trailingToSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
    return self.trailing(to: self.unwrappedSuperview, constant: constant)
  }
  
  func trailing(to otherView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
    return self.trailingAnchor.constraint(equalTo: otherView.trailingAnchor, constant: constant)
  }
  
  func centerXToSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
    return self.centerX(to: self.unwrappedSuperview, constant: constant)
  }
  
  func centerX(to otherView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
    return self.centerXAnchor.constraint(equalTo: otherView.centerXAnchor, constant: constant)
  }
  
  func centerYToSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
    return self.centerY(to: self.unwrappedSuperview, constant: constant)
  }
  
  func centerY(to otherView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
    return self.centerYAnchor.constraint(equalTo: otherView.centerYAnchor, constant: constant)
  }
}
