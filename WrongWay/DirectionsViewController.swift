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
  
  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = self
    manager.distanceFilter = 0.5
    manager.desiredAccuracy = kCLLocationAccuracyBest
    
    return manager
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
    
    locationManager.requestAlwaysAuthorization()
  }
  
  private func showDirections(_ directionsReponse: MKDirectionsResponse) {
    guard let line = directionsReponse.routes.first else {
      robot.speak(text: "We got nothing")
      return
    }
    
    self.mapView.add(line.polyline, level: .aboveRoads)
  }
}

extension DirectionsViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let firstLocation = locations.first else {
      return
    }
    
    let directionsRequest = MKDirectionsRequest()
    directionsRequest.transportType = .walking
    
    directionsRequest.source = firstLocation.placemark.mapItem
    directionsRequest.destination = destination.placemark.mapItem
    
    let directions = MKDirections(request: directionsRequest)
    
    directions.calculate {
      [weak self] directionsResponse, error in
      

      if let error = error {
        print("Error: \(error)")
        self?.robot.speak(text: "The programmer is a moron: \(error.localizedDescription)")
        return
      }
      
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways:
      robot.speak(text: "I am going to sell all your location data to the NSA.")
    case .authorizedWhenInUse:
      robot.speak(text: "All right, let's do this, motherfucker!")
    case .denied:
      robot.speak(text: "Well now you have to go to Settings, asshole.")
    case .restricted:
      robot.speak(text: "Come on, what kind of pre-teen are you if you don't know how to defeat parental restrictions?")
    case .notDetermined:
      robot.speak(text: "Just click the button, my pretty.")
    }
    
    manager.requestLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    robot.speak(text: "The programmer is a moron: \(error.localizedDescription)")
  }
}
