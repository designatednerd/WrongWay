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
  
  private let mapView: MKMapView = {
    let mapView = MKMapView(frame: .zero)
    mapView.translatesAutoresizingMaskIntoConstraints = false
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .follow
    
    return mapView
  }()
  
  private lazy var closeButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Close", for: .normal)
    button.backgroundColor = .red
    button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    button.layer.cornerRadius = 5
    button.clipsToBounds = true
    
    return button
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
  
  private var loadingScreen: LoadingScreen?
  
  private var route: MKRoute?
  
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
    self.view.addSubview(self.closeButton)
    self.mapView.delegate = self
    self.mapView.addAnnotation(self.destination.annotation)
    
    NSLayoutConstraint.activate(self.mapView.edgesToSuperview())
    NSLayoutConstraint.activate([
      self.closeButton.topToSuperview(constant: 40),
      self.closeButton.leadingToSuperview(constant: 20),
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
    self.robot.speak(text: "Move it, lazy-ass")
    self.startTimer()
  }
  
  private func startTimer() {
    Timer.scheduledTimer(withTimeInterval: 5,
                         repeats: true,
                         block: {
                  [weak self] timer in
                  guard let strongSelf = self else {
                    timer.invalidate()
                    return 
                  }
                  
                  strongSelf.checkOrInsult()
                })
  }
  
  private func checkOrInsult() {
    guard !isUserLocationOnPolyline() else {
      return
    }
    
    self.robot.speak(text: Discouragement.random)
  }
  
  private func showLoadingScreen(withText text: String) {
    let loading = self.loadingScreen ?? LoadingScreen()
    loading.text = text
    loading.alpha = 0
    if (self.loadingScreen == nil) {
      self.loadingScreen = loading
      self.view.addSubview(loading)
      NSLayoutConstraint.activate(loading.edgesToSuperview())
    }
    
    loading.show()
  }
  
  func hideLoadingScreen() {
    self.loadingScreen?.hide()
  }
  
  func isUserLocationOnPolyline() -> Bool {
    let annotation = self.mapView.userLocation
    
    guard let polyline = mapView.overlays.first as? MKPolyline else {
      return false
    }
    
    return polyline.closeEnough(to: annotation.coordinate)
  }
}

extension DirectionsViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if overlay is MKPolyline {
      let renderer = MKPolylineRenderer(overlay: overlay)
      renderer.strokeColor = .orange
      renderer.lineWidth = 5
      
      return renderer
    }
    
    return MKOverlayRenderer()
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard !(annotation is MKUserLocation) else {
      return nil
    }
    
    return MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
  }
}

extension DirectionsViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let firstLocation = locations.first else {
      return
    }
    
    self.mapView.setCenter(firstLocation.coordinate, animated: true)
    
    self.showLoadingScreen(withText: "Getting directions...")
    
    let directionsRequest = MKDirectionsRequest()
    directionsRequest.transportType = .walking
    
    directionsRequest.source = firstLocation.placemark.mapItem
    directionsRequest.destination = destination.placemark.mapItem
    
    let directions = MKDirections(request: directionsRequest)
    
    directions.calculate {
      [weak self] directionsResponse, error in
      
      self?.hideLoadingScreen()
      
      if let error = error {
        print("Error: \(error)")
        self?.robot.speak(text: "The programmer is a moron: \(error.localizedDescription)")
        return
      }
      
      guard let response = directionsResponse else {
        assertionFailure("No error and no response? Wat?")
        return
      }
      
      self?.showDirections(response)
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
    
    self.showLoadingScreen(withText: "Getting your location...")
    manager.requestLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    robot.speak(text: "The programmer is a moron: \(error.localizedDescription)")
    self.hideLoadingScreen()
  }
}
