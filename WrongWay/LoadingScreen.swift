//
//  LoadingScreen.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import UIKit

class LoadingScreen: UIView {
  
  private lazy var label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .white
    
    return label
  }()
  
  var text: String = "" {
    didSet {
      self.label.text = text
    }
  }
  
  init() {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    
    self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    stackView.spacing = 10
    
    self.addSubview(stackView)
    
    NSLayoutConstraint.activate([
        stackView.centerYToSuperview(),
        stackView.leadingToSuperview(constant: 20),
        stackView.trailingToSuperview(constant: 20)
    ])
    
    let spinner = UIActivityIndicatorView()
    spinner.activityIndicatorViewStyle = .whiteLarge
    stackView.addArrangedSubview(spinner)
    stackView.addArrangedSubview(label)
    
    self.hide(animated: false)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func show(animated: Bool = true) {
    self.setAlpha(1, animated: animated)
  }
  
  func hide(animated: Bool = true) {
    self.setAlpha(0, animated: animated)
  }
  
  private func setAlpha(_ alpha: CGFloat, animated: Bool) {
    guard self.alpha != alpha else {
      // We're already at the target. Bail.
      return
    }
    
    var duration: TimeInterval = 0
    if animated {
      duration = 0.3
    }
    
    UIView.animate(
      withDuration: duration,
      delay: 0,
      options: [.curveEaseInOut],
      animations: {
        self.alpha = alpha
      },
      completion: nil)
  }
}
