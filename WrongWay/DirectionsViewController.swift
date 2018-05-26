//
//  DirectionsViewController.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DirectionsViewController: UIViewController {
  
  private lazy var mapView: MKMapView = {
    let mapView = MKMapView(frame: .zero)
    mapView.translatesAutoresizingMaskIntoConstraints = false
    
    return mapView
  }()
  
  private let destination: GooglePlaceDetails
  
  private lazy var robot = RobotSpeaker()
  
  init(destination: GooglePlaceDetails) {
    self.destination = destination
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(self.mapView)
    
    NSLayoutConstraint.activate([
      self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      ])
    
    self.mapView.setRegion(self.destination.geometry.viewport.coordinateRegion, animated: false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    robot.speak(text: "Oh nice work there, genius")
  }
}
