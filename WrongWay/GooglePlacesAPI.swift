//
//  GooglePlacesAPI.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import Foundation
import CoreLocation

enum GooglePlacesAPIError: Error {
  case badStatus(status: GooglePlacesStatus)
}

enum Endpoint: String {
  case autocomplete = "autocomplete/"
  case details = "details/"
  
  static let baseURLString = "https://maps.googleapis.com/maps/api/place/"
  
  func withParameters(_ parameters: [Parameter]) -> String {
    let fullEndpoint = Endpoint.baseURLString + self.rawValue
    let final = parameters.reduce(fullEndpoint) {
      existing, parameter in
      return parameter.append(to: existing)
    }
    
    return final
  }
}

enum Parameter {
  case key
  case format
  case input(inputString: String)
  case location(location: CLLocationCoordinate2D)
  case placeID(placeID: String)
  
  func append(to existing: String) -> String {
    let stringToAppend: String
    switch self {
    case .key:
      stringToAppend = "&key=\(APIKey.GoogleMaps.rawValue)"
    case .format:
      stringToAppend = "json?"
    case .input(let inputString):
      guard let encodedInput = inputString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        stringToAppend = ""
        break
      }
      stringToAppend = "&input=\(encodedInput)"
    case .location(let location):
      stringToAppend = "&location=\(location.latitude),\(location.longitude)"
    case .placeID(let placeID):
      stringToAppend = "&placeid=\(placeID)"
    }
    
    return existing + stringToAppend
  }
}


struct GooglePlacesAPI {
  
  static func autocomplete(text: String,
                           failure: @escaping (Error) -> Void,
                           success: @escaping ([GooglePlace]) -> Void) -> URLSessionTask? {
    
    let urlString = Endpoint.autocomplete.withParameters([
        .format,
        .key,
        .input(inputString: text),
    ])
    
    return Internets.getData(
      from: urlString,
      success: {
        data in
        guard let wrapper: AutocompleteWrapper = data.decode() else {
          failure(InternetsError.jsonDecodingFailed)
          return
        }
        
        switch wrapper.status {
        case .OK,
             .ZERO_RESULTS:
          success(wrapper.predictions)
        case .INVALID_REQUEST,
             .OVER_QUERY_LIMIT,
             .REQUEST_DENIED,
             .UNKNOWN_ERROR:
          failure(GooglePlacesAPIError.badStatus(status: wrapper.status))
        }
      },
      failure: failure)
  }
  
  static func placeDetails(for place: GooglePlace,
                           failure: @escaping (Error) -> Void,
                           success: @escaping (GooglePlaceDetails) -> Void) -> URLSessionTask? {
    
    let urlString = Endpoint.details.withParameters([
        .format,
        .key,
        .placeID(placeID: place.placeID)
    ])
    
    return Internets.getData(
      from: urlString,
      success: {
        data in
        guard let wrapper: PlaceDetailsWrapper = data.decode() else {
          failure(InternetsError.jsonDecodingFailed)
          return
        }
        
        switch wrapper.status {
        case .OK:
          success(wrapper.result)
        case .INVALID_REQUEST,
             .OVER_QUERY_LIMIT,
             .REQUEST_DENIED,
             .ZERO_RESULTS,
             .UNKNOWN_ERROR:
          failure(GooglePlacesAPIError.badStatus(status: wrapper.status))
        }
      },
      failure: failure)
  }
}
