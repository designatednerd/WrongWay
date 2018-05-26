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
  
  @IBOutlet private var resultTableView: UITableView!
  
  private lazy var dataSource = AutocompleteDataSource(tableView: self.resultTableView,
                                                       delegate: self)
  private var currentTask: URLSessionTask?
}

extension ViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let updated = String.proposed(from: textField,
                                  changingCharactersIn: range,
                                  replacementString: string)
    
    self.currentTask?.cancel()
    self.currentTask = GooglePlacesAPI
      .autocomplete(text: updated,
                    failure: {
                      [weak self] error in
                      print("ERRORZ: \(error)")
                    },
                    success: {
                      [weak self] places in
                      print("Places: \(places)")
                      self?.dataSource.results = places
                      self?.resultTableView.reloadData()
                    })
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}

extension ViewController: AutocompleteDataSourceDelegate {
  
  func selectedPlace(_ place: GooglePlace) {
    print("Selected \(place.placeDescription)")
  }
}

