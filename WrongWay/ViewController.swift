//
//  ViewController.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController {
  
  @IBOutlet private var textField: UITextField!
  @IBOutlet private var mapView: MKMapView!
  
  @IBOutlet private var tableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet private var resultTableView: UITableView!
  
  private lazy var dataSource = AutocompleteDataSource(tableView: self.resultTableView,
                                                       delegate: self)
  private var currentTask: URLSessionTask?
  
  private var destination: GooglePlaceDetails?
  private var destinationAnnotation: MKAnnotation?
  
  func showPlace(place: GooglePlaceDetails) {
    self.destination = place
    if let oldDestinationAnnotation = self.destinationAnnotation {
      self.mapView.removeAnnotation(oldDestinationAnnotation)
    }
    self.mapView.setRegion(place.geometry.viewport.coordinateRegion, animated: true)
    
    let annotation = place.annotation
    self.destinationAnnotation = annotation
    self.mapView.addAnnotation(annotation)
  }
  
  func updateResults(to results: [GooglePlace]) {
    self.dataSource.results = results
    self.resultTableView.reloadData()
    self.adjustTableViewHeightToFitResults()
  }
}

extension ViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let updated = String.proposed(from: textField,
                                  changingCharactersIn: range,
                                  replacementString: string)
    
    self.currentTask?.cancel()
    self.currentTask = GooglePlacesAPI.autocomplete(
      text: updated,
      failure: {
        error in
        print("ERRORZ: \(error)")
      },
      success: {
        [weak self] places in
        print("Places: \(places)")
        self?.currentTask = nil
        self?.updateResults(to: places)
      })
    return true
  }

  private func adjustTableViewHeightToFitResults() {
    let maxHeight = self.view.safeAreaLayoutGuide.layoutFrame.height - 20
    let maxEffectiveHeight = CGFloat.minimum(self.resultTableView.contentSize.height, maxHeight)
    
    self.tableViewHeightConstraint.constant = CGFloat.maximum(0, maxEffectiveHeight)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}

extension ViewController: AutocompleteDataSourceDelegate {
  
  func selectedPlace(_ place: GooglePlace) {
    print("Selected \(place.placeDescription)")
    self.destination = nil
    self.textField.text = place.placeDescription
    self.updateResults(to: [])
    self.currentTask?.cancel()
    
    self.currentTask = GooglePlacesAPI.placeDetails(
      for: place,
      failure: {
        error in
        print("ERRORZ: \(error)")
      },
      success: {
        [weak self] details in
        self?.showPlace(place: details)
      })
  }
}

extension ViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
    pinView.canShowCallout = true
    
    let goButton = UIButton(type: .custom)
    goButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    goButton.layer.cornerRadius = 5
    goButton.clipsToBounds = true
    goButton.backgroundColor = .blue
    goButton.setTitle("GO!", for: .normal)
    goButton.sizeToFit()
    pinView.leftCalloutAccessoryView = goButton
    
    return pinView
  }
  
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    if let destination = self.destinationAnnotation {
      mapView.selectAnnotation(destination, animated: true)
    }
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let destination = self.destination else {
      assertionFailure("Trying to select a destination that doesn't exist. wat")
      return
    }
    let directionsVC = DirectionsViewController(destination: destination)
    self.present(directionsVC, animated: false, completion: nil)
  }
}

