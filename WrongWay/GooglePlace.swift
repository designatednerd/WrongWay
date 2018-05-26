//
//  GooglePlace.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import Foundation
import MapKit

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

struct GooglePlaceDetails: Codable {
  let id: String
  let placeID: String
  let address: String
  let geometry: GoogleMapGeometry
  
  enum CodingKeys: String, CodingKey {
    case id
    case placeID = "place_id"
    case address = "formatted_address"
    case geometry
  }
  
  
  var annotation: MKAnnotation {
    let pointAnnotation = MKPointAnnotation()
    pointAnnotation.title = self.address
    pointAnnotation.coordinate = self.geometry.location.coordinate
    
    return pointAnnotation
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

struct PlaceDetailsWrapper: Codable {
  let status: GooglePlacesStatus
  let result: GooglePlaceDetails
  
  enum CodingKeys: String, CodingKey {
    case status
    case result
  }
}
