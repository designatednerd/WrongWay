//
//  GoogleMapInfo.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

struct GoogleMapCoordinate: Codable {
  let latitude: Double
  let longitude: Double
  
  enum CodingKeys: String, CodingKey {
    case latitude = "lat"
    case longitude = "lng"
  }
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: self.latitude,
                                  longitude: self.longitude)
  }
}

struct GoogleMapViewport: Codable {
  let northeast: GoogleMapCoordinate
  let southwest: GoogleMapCoordinate
  
  enum CodingKeys: String, CodingKey {
    case northeast
    case southwest
  }
  
  var span: MKCoordinateSpan {
    let latitudeSpan = abs(northeast.latitude - southwest.latitude)
    let longitudeSpan = abs(northeast.longitude - southwest.longitude)
    
    return MKCoordinateSpan(latitudeDelta: latitudeSpan,
                            longitudeDelta: longitudeSpan)
  }
  
  var center: CLLocationCoordinate2D {
    let centerLatitude = (northeast.latitude + southwest.latitude) / 2
    
    let centerLongitude = (northeast.longitude + southwest.longitude) / 2
    return CLLocationCoordinate2D(latitude: centerLatitude,
                                  longitude: centerLongitude)
  }
  
  var coordinateRegion: MKCoordinateRegion {
    return MKCoordinateRegion(center: self.center,
                              span: self.span)
  }
}

struct GoogleMapGeometry: Codable {
  let location: GoogleMapCoordinate
  let viewport: GoogleMapViewport
  
  enum CodingKeys: String, CodingKey {
    case location
    case viewport
  }
}
