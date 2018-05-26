//
//  GooglePlace.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import Foundation

struct GooglePlace: Codable {
  
  let id: String
  let placeID: String
  let placeDescription: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case placeID = "place_id"
    case placeDescription = "description"
  }
}

struct AutocompleteWrapper: Codable {
  let status: GooglePlacesStatus
  let predictions: [GooglePlace]
  let errorMessage: String?
  
  enum CodingKeys: String, CodingKey {
    case status
    case predictions
    case errorMessage = "error_message"
  }
}
