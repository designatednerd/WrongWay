//
//  AutocompleteDataSource.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import UIKit

protocol AutocompleteDataSourceDelegate: class {
  func selectedPlace(_ place: GooglePlace)
}

class AutocompleteDataSource: NSObject {
  weak var delegate: AutocompleteDataSourceDelegate?
  var results = [GooglePlace]()
  private let identifier = "I AM A CELL AND YOU AREN'T"
  
  init(tableView: UITableView,
       delegate: AutocompleteDataSourceDelegate) {
    super.init()
    self.delegate = delegate

    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
  }
}

extension AutocompleteDataSource: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let result = results[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath)
    
    cell.textLabel?.text = result.placeDescription
    
    return cell
  }
}

extension AutocompleteDataSource: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selected = self.results[indexPath.row]
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    guard let delegate = self.delegate else {
      assertionFailure("You sure you don't want ta delegate there, goober?")
      return
    }
    
    delegate.selectedPlace(selected)
  }
}
