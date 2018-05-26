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
    
    return Internets.getData(from: urlString,
                      success: {
                        data in
                        guard let wrapper: AutocompleteWrapper = data.decode() else {
                          failure(InternetsError.jsonDecodingFailed)
                          return
                        }
                        
                        guard wrapper.status == GooglePlacesStatus.OK else {
                          failure(GooglePlacesAPIError.badStatus(status: wrapper.status))
                          return
                        }
                        
                        success(wrapper.predictions)
                      },
                      failure: failure)
  }
}
